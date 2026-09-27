import consumer from "consumer"

// Module-level state — survives across Turbo navigations, cleaned up on turbo:before-cache
let chatInitialized = false
let chatSubscription = null
let badgeIntervalId = null
let conversationPollIntervalId = null

function destroyChatWidget() {
  chatInitialized = false
  if (chatSubscription) { chatSubscription.unsubscribe(); chatSubscription = null }
  if (badgeIntervalId) { clearInterval(badgeIntervalId); badgeIntervalId = null }
  if (conversationPollIntervalId) { clearInterval(conversationPollIntervalId); conversationPollIntervalId = null }
  const chatWidget = document.getElementById('chat-widget')
  if (chatWidget) delete chatWidget.dataset.initialized
}

document.addEventListener('turbo:before-cache', destroyChatWidget)

function initializeChatWidget() {
  const chatWidget = document.getElementById('chat-widget')
  if (!chatWidget || chatInitialized) return
  chatInitialized = true
  chatWidget.dataset.initialized = 'true'

  const chatToggle = document.getElementById('chat-toggle')
  const chatBox = document.getElementById('chat-box')
  const chatClose = document.getElementById('chat-close')
  const chatForm = document.getElementById('chat-form')
  const chatInput = document.getElementById('chat-input')
  const chatMessages = document.getElementById('chat-messages')
  const approvalHint = document.getElementById('chat-approval-hint')
  let latestUnreadSenderId = null
  let unreadBySender = {}
  let activeConversationUserId = null
  let isSubmitting = false

  // ─── Action Cable subscription ───────────────────────────────────────────
  const currentUserId = document.querySelector('meta[name="current-user-id"]')?.content
  if (currentUserId) {
    chatSubscription = consumer.subscriptions.create("ChatChannel", {
      received(data) {
        if (data.type === 'new_message') {
          handleIncomingMessage(data)
        } else if (data.type === 'unread_update') {
          applyUnreadData(data)
        }
      }
    })
  }

  function handleIncomingMessage(data) {
    const senderId = String(data.sender_id || data.message?.sender?.id || '')
    const isChatOpen = chatBox && !chatBox.classList.contains('hidden')
    const isActiveSender = activeConversationUserId === senderId

    if (isChatOpen && isActiveSender) {
      // Conversation with this sender is open — append message and mark read
      addMessage(data.message.message, 'other')
      markConversationRead(senderId)
    } else {
      // Not currently viewing — just flash badge (unread_update will follow)
      flashToggleButton()
    }
  }

  function flashToggleButton() {
    const btn = document.getElementById('chat-toggle')
    if (!btn) return
    btn.classList.add('animate-bounce')
    setTimeout(() => btn.classList.remove('animate-bounce'), 1500)
  }

  function markConversationRead(userId) {
    // Re-fetch the conversation — this marks messages as read server-side
    fetch(`/support_chat_messages/conversations/${userId}.json`, {
      headers: { 'Accept': 'application/json' },
      credentials: 'same-origin'
    }).then(r => r.ok ? r.json() : null).then(data => {
      if (data?.success) setTimeout(updateAllUnreadBadges, 100)
    }).catch(() => {})
  }

  // ─── Draggable ────────────────────────────────────────────────────────────
  let isDragging = false, dragPending = false
  let startX, startY, initialX, initialY
  const dragThreshold = 6

  function startDrag(e) {
    if (!e.target.closest('.drag-handle')) return
    dragPending = true
    isDragging = false
    startX = e.type === 'touchstart' ? e.touches[0].clientX : e.clientX
    startY = e.type === 'touchstart' ? e.touches[0].clientY : e.clientY
    const match = chatWidget.style.transform?.match(/translate3d\(([-\d.]+)px,\s*([-\d.]+)px/)
    initialX = match ? parseFloat(match[1]) : 0
    initialY = match ? parseFloat(match[2]) : 0
    if (e.type === 'mousedown') e.preventDefault()
  }

  function doDrag(e) {
    if (!dragPending) return
    const currentX = e.type === 'touchmove' ? e.touches[0].clientX : e.clientX
    const currentY = e.type === 'touchmove' ? e.touches[0].clientY : e.clientY
    const deltaX = currentX - startX, deltaY = currentY - startY
    if (!isDragging) {
      if (Math.abs(deltaX) < dragThreshold && Math.abs(deltaY) < dragThreshold) return
      isDragging = true
    }
    e.preventDefault()
    const newX = initialX + deltaX, newY = initialY + deltaY
    chatWidget.style.transform = `translate3d(${newX}px, ${newY}px, 0)`
    localStorage.setItem('chatWidgetPosition', JSON.stringify({ x: newX, y: newY }))
  }

  function stopDrag() { isDragging = false; dragPending = false }

  chatWidget.addEventListener('mousedown', startDrag)
  chatWidget.addEventListener('touchstart', startDrag)
  document.addEventListener('mousemove', doDrag)
  document.addEventListener('touchmove', doDrag, { passive: false })
  document.addEventListener('mouseup', stopDrag)
  document.addEventListener('touchend', stopDrag)

  function getCurrentTranslation() {
    const match = chatWidget.style.transform?.match(/translate3d\(([-\d.]+)px,\s*([-\d.]+)px/)
    return match ? { x: parseFloat(match[1]), y: parseFloat(match[2]) } : { x: 0, y: 0 }
  }

  function persistPosition(x, y) {
    chatWidget.style.transform = `translate3d(${x}px, ${y}px, 0)`
    localStorage.setItem('chatWidgetPosition', JSON.stringify({ x, y }))
  }

  function keepWidgetInViewport() {
    const margin = 8
    const current = getCurrentTranslation()
    chatWidget.style.transform = 'translate3d(0px, 0px, 0px)'
    const baseRect = chatWidget.getBoundingClientRect()
    const clampedX = Math.max(margin - baseRect.left, Math.min((window.innerWidth - margin) - baseRect.right, current.x))
    const clampedY = Math.max(margin - baseRect.top, Math.min((window.innerHeight - margin) - baseRect.bottom, current.y))
    persistPosition(clampedX, clampedY)
  }

  function loadPosition() {
    try {
      const saved = localStorage.getItem('chatWidgetPosition')
      if (saved) { const { x, y } = JSON.parse(saved); persistPosition(x, y) }
      keepWidgetInViewport()
    } catch (e) {}
  }

  window.addEventListener('resize', keepWidgetInViewport)

  // ─── Toggle ───────────────────────────────────────────────────────────────
  if (chatToggle) {
    chatToggle.addEventListener('click', function(e) {
      if (isDragging) return
      chatBox.classList.toggle('hidden')
      if (!chatBox.classList.contains('hidden')) {
        setTimeout(() => chatInput?.focus(), 100)
        if (chatMessages?.children.length === 0) addWelcomeMessage()
        updateAllUnreadBadges()
        if (userSelect && latestUnreadSenderId) {
          const sel = userSelect.value ? String(userSelect.value) : null
          if (!sel || (unreadBySender[sel] || 0) === 0) {
            const opt = Array.from(userSelect.options).find(o => o.value === String(latestUnreadSenderId))
            if (opt) { userSelect.value = String(latestUnreadSenderId); userSelect.dispatchEvent(new Event('change')) }
          }
        }
      }
      e.stopPropagation()
    })
  }

  if (chatClose) {
    chatClose.addEventListener('click', function(e) {
      chatBox.classList.add('hidden')
      e.stopPropagation()
    })
  }

  if (chatInput) {
    chatInput.addEventListener('input', function() {
      this.style.height = 'auto'
      this.style.height = Math.min(this.scrollHeight, 120) + 'px'
    })
  }

  // ─── User select (support/admin only) ────────────────────────────────────
  const userSelect = document.getElementById('support-user-select')
  const sendButton = document.getElementById('send-button')

  if (userSelect) {
    userSelect.addEventListener('change', function() {
      const isSelected = this.value !== ''
      const requiresApproval = this.options[this.selectedIndex]?.dataset?.requiresApproval === 'true'
      if (chatInput) chatInput.disabled = !isSelected || isSubmitting
      if (sendButton) sendButton.disabled = !isSelected || isSubmitting
      if (approvalHint) approvalHint.classList.toggle('hidden', !isSelected || !requiresApproval)
      if (isSelected) {
        activeConversationUserId = this.value
        if (requiresApproval) {
          clearChatMessages()
          addMessage(`Chat with ${this.options[this.selectedIndex]?.text || 'this contact'} needs support approval first.`, 'bot')
        } else {
          loadConversation(this.value)
        }
        setTimeout(() => chatInput?.focus(), 100)
      } else {
        activeConversationUserId = null
        clearChatMessages()
        addWelcomeMessage()
      }
    })
  }

  // ─── Form submit ──────────────────────────────────────────────────────────
  if (chatForm) {
    chatForm.addEventListener('submit', function(e) {
      e.preventDefault()
      if (isSubmitting) return
      const message = chatInput?.value.trim()
      if (!message) {
        chatInput?.focus()
        if (chatInput) { chatInput.style.borderColor = 'red'; setTimeout(() => { chatInput.style.borderColor = '' }, 2000) }
        return
      }
      if (userSelect && !userSelect.value) { userSelect.focus(); return }

      const formData = new FormData(this)
      isSubmitting = true
      if (chatInput) chatInput.disabled = true
      if (sendButton) sendButton.disabled = true
      const typingIndicator = addTypingIndicator()

      fetch(this.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || '',
          'Accept': 'application/json'
        }
      })
      .then(async r => { const d = await r.json().catch(() => ({})); return r.ok ? d : { success: false, ...d } })
      .then(data => {
        typingIndicator.remove()
        if (data.success) {
          addMessage(message, 'user')
          if (chatInput) { chatInput.value = ''; chatInput.style.height = 'auto' }
          // Refresh conversation after short delay to pick up any server-side updates
          if (userSelect?.value) {
            setTimeout(() => loadConversation(userSelect.value, { showLoader: false, suppressErrors: true }), 500)
          }
        } else if (data.requires_approval) {
          addMessage(data.message || "This chat requires support approval first.", 'bot')
        }
      })
      .catch(error => { console.error('Chat send error:', error); typingIndicator.remove() })
      .finally(() => {
        isSubmitting = false
        if (chatInput) chatInput.disabled = !!(userSelect && !userSelect.value)
        if (sendButton) sendButton.disabled = !!(userSelect && !userSelect.value)
      })
    })
  }

  // ─── Conversation loading ─────────────────────────────────────────────────
  function loadConversation(userId, options = {}) {
    if (!chatMessages) return
    const showLoader = options.showLoader !== false
    const suppressErrors = options.suppressErrors === true
    const normalizedId = String(userId || '').trim()
    if (!/^\d+$/.test(normalizedId)) return

    activeConversationUserId = normalizedId
    const hadMessages = chatMessages.children.length > 0
    let loadingDiv = null

    if (showLoader) {
      loadingDiv = document.createElement('div')
      loadingDiv.className = 'flex justify-start'
      loadingDiv.innerHTML = `<div class="bg-gray-200 text-gray-800 rounded-lg rounded-bl-none p-3"><div class="flex space-x-1"><div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div><div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:0.1s"></div><div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:0.2s"></div></div></div>`
      chatMessages.appendChild(loadingDiv)
    }

    fetch(`/support_chat_messages/conversations/${normalizedId}.json`, {
      headers: { 'Accept': 'application/json' },
      credentials: 'same-origin'
    })
    .then(async r => {
      const ct = r.headers.get('content-type') || ''
      if (r.redirected || !ct.includes('application/json')) throw new Error('invalid_response')
      const d = await r.json().catch(() => ({}))
      if (!r.ok) throw new Error(d.message || 'load_failed')
      return d
    })
    .then(data => {
      loadingDiv?.remove()
      clearChatMessages()
      if (data.access_denied) {
        addMessage(data.message || 'This conversation needs support approval first.', 'bot')
        return
      }
      if (Array.isArray(data.messages) && data.messages.length > 0) {
        data.messages.forEach(msg => {
          const isMe = msg.sender.id === data.current_user.id
          addMessage(msg.message, isMe ? 'user' : 'other')
        })
      } else {
        addMessage("No previous messages. Start the conversation!", 'bot')
      }
      setTimeout(updateAllUnreadBadges, 150)
    })
    .catch(error => {
      loadingDiv?.remove()
      if (suppressErrors) return
      if (!hadMessages && chatMessages.children.length === 0) addMessage('No previous messages. Start the conversation!', 'bot')
    })
  }

  // ─── Badge updates ────────────────────────────────────────────────────────
  function updateAllUnreadBadges() {
    if (!currentUserId) return
    fetch('/support_chat_messages/unread_counts', { credentials: 'same-origin' })
      .then(r => r.json())
      .then(data => applyUnreadData(data))
      .catch(() => {})
  }

  function applyUnreadData(data) {
    const total = data.total_unread || 0
    latestUnreadSenderId = data.latest_unread_sender_id || null
    unreadBySender = data.unread_by_sender || {}

    const toggleBadge = document.getElementById('chat-toggle-badge')
    if (toggleBadge) {
      toggleBadge.textContent = total
      toggleBadge.classList.toggle('hidden', total === 0)
      toggleBadge.classList.toggle('animate-pulse', total > 0)
    }

    const headerBadge = document.getElementById('chat-header-badge')
    if (headerBadge) {
      headerBadge.textContent = `${total} unread`
      headerBadge.classList.toggle('hidden', total === 0)
    }

    const userUnreadMsg = document.getElementById('user-unread-message')
    if (userUnreadMsg) {
      if (total > 0) {
        userUnreadMsg.textContent = `You have ${total} unread message${total === 1 ? '' : 's'}`
        userUnreadMsg.classList.remove('hidden')
      } else {
        userUnreadMsg.classList.add('hidden')
      }
    }

    const sel = document.getElementById('support-user-select')
    if (sel) {
      Array.from(sel.options).forEach(opt => {
        if (!opt.value) return
        const base = opt.dataset.baseLabel || opt.text
        opt.dataset.baseLabel = base
        const count = unreadBySender[opt.value] || 0
        if (count > 0) {
          opt.text = `${base} (${count} unread)`
          opt.style.color = '#dc2626'
          opt.style.fontWeight = '600'
        } else {
          opt.text = base
          opt.style.color = ''
          opt.style.fontWeight = ''
        }
      })
    }
  }

  // ─── Conversation list badges (support/admin sidebar) ────────────────────
  function updateConversationListBadges(unreadBySender) {
    document.querySelectorAll('[data-conversation-user-id]').forEach(el => {
      const uid = el.dataset.conversationUserId
      const badge = el.querySelector('.unread-badge')
      const count = unreadBySender[uid] || 0
      if (badge) {
        badge.textContent = count > 0 ? `${count} unread` : ''
        badge.classList.toggle('hidden', count === 0)
      }
    })
  }

  // ─── Message helpers ──────────────────────────────────────────────────────
  function clearChatMessages() {
    if (!chatMessages) return
    while (chatMessages.firstChild) chatMessages.removeChild(chatMessages.firstChild)
  }

  function addWelcomeMessage() {
    const isSupport = document.querySelector('meta[name="current-user-role"]')?.content === 'support' ||
                      document.querySelector('meta[name="current-user-role"]')?.content === 'admin'
    if (isSupport) {
      addMessage("👋 Admin/Support chat mode. Select a user from the dropdown below.", 'bot')
    } else {
      addMessage("Hello! 👋 How can we help you today?", 'bot')
      addMessage("We typically reply within minutes", 'bot')
    }
  }

  function addMessage(text, sender) {
    if (!chatMessages) return
    const div = document.createElement('div')
    let bubbleClass
    if (sender === 'user') {
      div.className = 'flex justify-end mb-2'
      bubbleClass = 'bg-green-600 text-white rounded-lg rounded-br-none p-3 max-w-xs text-sm'
    } else if (sender === 'other') {
      div.className = 'flex justify-start mb-2'
      bubbleClass = 'bg-gray-200 text-gray-800 rounded-lg rounded-bl-none p-3 max-w-xs text-sm'
    } else {
      div.className = 'flex justify-start mb-2'
      bubbleClass = 'bg-blue-100 text-blue-800 rounded-lg rounded-bl-none p-3 max-w-xs text-sm'
    }
    const bubble = document.createElement('div')
    bubble.className = bubbleClass
    bubble.textContent = text
    div.appendChild(bubble)
    chatMessages.appendChild(div)
    chatMessages.scrollTop = chatMessages.scrollHeight
  }

  function addTypingIndicator() {
    if (!chatMessages) return document.createElement('div')
    const div = document.createElement('div')
    div.className = 'flex justify-start mb-2'
    const bubble = document.createElement('div')
    bubble.className = 'bg-gray-200 text-gray-800 rounded-lg rounded-bl-none p-3'
    bubble.innerHTML = `<div class="flex space-x-1"><div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div><div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:0.1s"></div><div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay:0.2s"></div></div>`
    div.appendChild(bubble)
    chatMessages.appendChild(div)
    chatMessages.scrollTop = chatMessages.scrollHeight
    return div
  }

  // ─── Fallback polling (Action Cable handles real-time; this is a safety net) ─
  if (currentUserId) {
    badgeIntervalId = setInterval(updateAllUnreadBadges, 60000)
  }

  // ─── Close on outside click ───────────────────────────────────────────────
  document.addEventListener('click', function(e) {
    if (chatBox && !chatBox.classList.contains('hidden') &&
        chatToggle && !chatBox.contains(e.target) && !chatToggle.contains(e.target)) {
      chatBox.classList.add('hidden')
    }
  })

  chatWidget.addEventListener('click', e => e.stopPropagation())

  // ─── Visibility change: refresh badges when tab regains focus ─────────────
  document.addEventListener('visibilitychange', function() {
    if (!document.hidden && currentUserId) setTimeout(updateAllUnreadBadges, 500)
  })

  // ─── Init ─────────────────────────────────────────────────────────────────
  loadPosition()

  setTimeout(() => {
    if (chatMessages?.children.length === 0) addWelcomeMessage()
    if (currentUserId) updateAllUnreadBadges()
  }, 300)
}

document.addEventListener('DOMContentLoaded', initializeChatWidget)
document.addEventListener('turbo:load', initializeChatWidget)
if (document.readyState !== 'loading') initializeChatWidget()
