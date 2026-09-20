// app/javascript/chat_widget.js - UPDATED AND FIXED
function initializeChatWidget() {
  const chatWidget = document.getElementById('chat-widget');
  if (!chatWidget) return;
  if (chatWidget.dataset.initialized === 'true') return;
  chatWidget.dataset.initialized = 'true';

  const chatToggle = document.getElementById('chat-toggle');
  const chatBox = document.getElementById('chat-box');
  const chatClose = document.getElementById('chat-close');
  const chatForm = document.getElementById('chat-form');
  const chatInput = document.getElementById('chat-input');
  const chatMessages = document.getElementById('chat-messages');
  const approvalHint = document.getElementById('chat-approval-hint');
  let isSubmitting = false;

  // Draggable functionality - SIMPLIFIED VERSION
  let isDragging = false;
  let dragPending = false;
  let startX, startY, initialX, initialY;
  const dragThreshold = 6;
  
  // Make chat widget draggable
  function startDrag(e) {
    // Only drag if clicking on the button or header with drag-handle class
    if (e.target.closest('.drag-handle')) {
      dragPending = true;
      isDragging = false;
      
      // Get initial mouse/touch position
      if (e.type === 'touchstart') {
        startX = e.touches[0].clientX;
        startY = e.touches[0].clientY;
      } else {
        startX = e.clientX;
        startY = e.clientY;
      }
      
      // Get initial widget position
      const transform = chatWidget.style.transform;
      if (transform) {
        const match = transform.match(/translate3d\(([-\d.]+)px,\s*([-\d.]+)px/);
        if (match) {
          initialX = parseFloat(match[1]) || 0;
          initialY = parseFloat(match[2]) || 0;
        } else {
          initialX = 0;
          initialY = 0;
        }
      } else {
        initialX = 0;
        initialY = 0;
      }
      
      // Prevent text selection on mouse; allow taps to register on touch
      if (e.type === 'mousedown') {
        e.preventDefault();
      }
    }
  }
  
  function doDrag(e) {
    if (!dragPending) return;
    
    let currentX, currentY;
    if (e.type === 'touchmove') {
      currentX = e.touches[0].clientX;
      currentY = e.touches[0].clientY;
    } else {
      currentX = e.clientX;
      currentY = e.clientY;
    }
    
    // Calculate new position
    const deltaX = currentX - startX;
    const deltaY = currentY - startY;

    if (!isDragging) {
      if (Math.abs(deltaX) < dragThreshold && Math.abs(deltaY) < dragThreshold) {
        return;
      }
      isDragging = true;
    }

    e.preventDefault();

    const newX = initialX + deltaX;
    const newY = initialY + deltaY;
    
    // Apply transform
    chatWidget.style.transform = `translate3d(${newX}px, ${newY}px, 0)`;
    
    // Save position
    localStorage.setItem('chatWidgetPosition', JSON.stringify({
      x: newX,
      y: newY
    }));
  }
  
  function stopDrag() {
    isDragging = false;
    dragPending = false;
  }
  
  // Add event listeners for dragging
  chatWidget.addEventListener('mousedown', startDrag);
  chatWidget.addEventListener('touchstart', startDrag);
  
  document.addEventListener('mousemove', doDrag);
  document.addEventListener('touchmove', doDrag, { passive: false });
  
  document.addEventListener('mouseup', stopDrag);
  document.addEventListener('touchend', stopDrag);

  // Load saved position
  function getCurrentTranslation() {
    const transform = chatWidget.style.transform;
    if (!transform) return { x: 0, y: 0 };

    const match = transform.match(/translate3d\(([-\d.]+)px,\s*([-\d.]+)px/);
    if (!match) return { x: 0, y: 0 };

    return {
      x: parseFloat(match[1]) || 0,
      y: parseFloat(match[2]) || 0
    };
  }

  function persistPosition(x, y) {
    chatWidget.style.transform = `translate3d(${x}px, ${y}px, 0)`;
    localStorage.setItem('chatWidgetPosition', JSON.stringify({ x, y }));
  }

  function keepWidgetInViewport() {
    const margin = 8;
    const current = getCurrentTranslation();

    // Compute bounds from the widget's natural fixed position (no translation)
    // and clamp the current translation into those bounds.
    chatWidget.style.transform = 'translate3d(0px, 0px, 0px)';
    const baseRect = chatWidget.getBoundingClientRect();

    const minX = margin - baseRect.left;
    const maxX = (window.innerWidth - margin) - baseRect.right;
    const minY = margin - baseRect.top;
    const maxY = (window.innerHeight - margin) - baseRect.bottom;

    const clampedX = Math.max(minX, Math.min(maxX, current.x));
    const clampedY = Math.max(minY, Math.min(maxY, current.y));

    persistPosition(clampedX, clampedY);
  }

  function loadPosition() {
    try {
      const savedPosition = localStorage.getItem('chatWidgetPosition');
      if (savedPosition) {
        const { x, y } = JSON.parse(savedPosition);
        persistPosition(x, y);
      }

      keepWidgetInViewport();
    } catch (e) {
      console.error('Error loading chat position:', e);
    }
  }

  window.addEventListener('resize', keepWidgetInViewport);

  // Toggle chat box - SIMPLIFIED
  if (chatToggle) {
    chatToggle.addEventListener('click', function(e) {
      // Only toggle if not dragging
      if (!isDragging) {
        console.log('Toggling chat box');
        chatBox.classList.toggle('hidden');
        
        if (!chatBox.classList.contains('hidden')) {
          // Chat is opening
          setTimeout(() => {
            if (chatInput) chatInput.focus();
          }, 100);
          
          // Load welcome message if empty
          if (chatMessages && chatMessages.children.length === 0) {
            addWelcomeMessage();
          }
          
          // Update unread counts
          updateAllUnreadBadges();
        }
        
        e.stopPropagation();
      }
    });
  }

  // Close chat box
  if (chatClose) {
    chatClose.addEventListener('click', function(e) {
      chatBox.classList.add('hidden');
      e.stopPropagation();
    });
  }

  // Auto-resize textarea
  if (chatInput) {
    chatInput.addEventListener('input', function() {
      this.style.height = 'auto';
      this.style.height = Math.min(this.scrollHeight, 120) + 'px';
    });
  }

  // Handle support user selection
  const userSelect = document.getElementById('support-user-select');
  const sendButton = document.getElementById('send-button');
  
  if (userSelect) {
    userSelect.addEventListener('change', function() {
      const isUserSelected = this.value !== '';
      const selectedOption = this.options[this.selectedIndex];
      const requiresApproval = selectedOption?.dataset?.requiresApproval === 'true';
      
      if (chatInput) chatInput.disabled = !isUserSelected || isSubmitting;
      if (sendButton) sendButton.disabled = !isUserSelected || isSubmitting;

      if (approvalHint) {
        approvalHint.classList.toggle('hidden', !isUserSelected || !requiresApproval);
      }
      
      if (isUserSelected) {
        // Clear and load conversation
        clearChatMessages();
        if (requiresApproval) {
          const contactLabel = selectedOption?.text || 'this contact';
          addMessage(`Chat access with ${contactLabel} needs support approval first. Send one message to request approval, or message support now.`, 'bot');
        } else {
          loadConversation(this.value);
        }
        
        // Focus on input
        setTimeout(() => {
          if (chatInput) chatInput.focus();
        }, 100);
      } else {
        // Clear messages if no user selected
        clearChatMessages();
        addWelcomeMessage();
      }
    });
  }

  // Handle form submission
  if (chatForm) {
    chatForm.addEventListener('submit', function(e) {
      e.preventDefault();
      if (isSubmitting) return;

      const message = chatInput?.value.trim();
      
      // Validation
      if (!message || message.length === 0) {
        alert('Please type a message before sending.');
        if (chatInput) {
          chatInput.focus();
          chatInput.style.borderColor = 'red';
          setTimeout(() => {
            if (chatInput) chatInput.style.borderColor = '';
          }, 2000);
        }
        return;
      }

      if (userSelect && !userSelect.value) {
        alert('Please select a user to chat with.');
        if (userSelect) userSelect.focus();
        return;
      }

      // Capture data before disabling fields; disabled inputs are omitted from FormData.
      const formData = new FormData(this);

      // Show typing indicator
      isSubmitting = true;
      if (chatInput) chatInput.disabled = true;
      if (sendButton) sendButton.disabled = true;

      const typingIndicator = addTypingIndicator();
      
      fetch(this.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content || '',
          'Accept': 'application/json'
        }
      })
      .then(async response => {
        const data = await response.json().catch(() => ({}));
        if (!response.ok) {
          return {
            success: false,
            requires_approval: !!data.requires_approval,
            message: data.message || `Server error: ${response.status}`
          };
        }
        return data;
      })
      .then(data => {
        typingIndicator.remove();

        if (data.success) {
          addMessage(message, 'user');
          
          if (chatInput) {
            chatInput.value = '';
            chatInput.style.height = 'auto';
          }
          
          addMessage("✓ Message sent!", 'bot');
          
          // Update unread badges
          setTimeout(updateAllUnreadBadges, 300);
          
          // Reload conversation if user selected
          if (userSelect && userSelect.value) {
            setTimeout(() => {
              loadConversation(userSelect.value);
            }, 1000);
          }
        } else if (data.requires_approval) {
          addMessage(data.message || "This chat requires support approval first.", 'bot');
        } else {
          addMessage(data.message || "Failed to send message.", 'bot');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        typingIndicator.remove();
        addMessage("Sorry, there was an error sending your message.", 'bot');
      })
      .finally(() => {
        isSubmitting = false;
        if (chatInput) {
          chatInput.disabled = !!(userSelect && !userSelect.value);
        }
        if (sendButton) {
          sendButton.disabled = !!(userSelect && !userSelect.value);
        }
      });
    });
  }

  // Function to load conversation
  function loadConversation(userId) {
    if (!chatMessages) return;

    const normalizedUserId = String(userId || '').trim();
    if (!/^\d+$/.test(normalizedUserId)) {
      addMessage('Please choose a valid contact from the list.', 'bot');
      return;
    }
    
    const loadingDiv = document.createElement('div');
    loadingDiv.className = 'flex justify-start';
    loadingDiv.innerHTML = `
      <div class="bg-gray-200 text-gray-800 rounded-lg rounded-bl-none p-3">
        <div class="flex space-x-1">
          <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
          <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
          <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
        </div>
      </div>
    `;
    chatMessages.appendChild(loadingDiv);

    fetch(`/support_chat_messages/conversations/${normalizedUserId}.json`)
      .then(async response => {
        const data = await response.json().catch(() => ({}));
        if (!response.ok) {
          const fallbackText = response.status === 404
            ? 'Selected contact was not found.'
            : 'Failed to load conversation';
          throw new Error(data.message || fallbackText);
        }
        return data;
      })
      .then(data => {
        loadingDiv.remove();
        clearChatMessages();

        if (data.access_denied) {
          addMessage(data.message || 'This conversation needs support approval first.', 'bot');
          return;
        }
        
        addMessage(`Chatting with ${data.other_user.name}`, 'bot');
        
        if (data.messages && data.messages.length > 0) {
          data.messages.forEach(msg => {
            const isCurrentUser = msg.sender.id === data.current_user.id;
            addMessage(msg.message, isCurrentUser ? 'user' : 'other');
          });
          
          // Update badges after loading
          setTimeout(updateAllUnreadBadges, 300);
        } else {
          addMessage("No previous messages. Start the conversation!", 'bot');
        }
      })
      .catch(error => {
        console.error('Error loading conversation:', error);
        loadingDiv.remove();
        addMessage(error.message || "Failed to load conversation. Please try again.", 'bot');
      });
  }

  function clearChatMessages() {
    if (!chatMessages) return;
    
    while (chatMessages.firstChild) {
      chatMessages.removeChild(chatMessages.firstChild);
    }
  }

  function addWelcomeMessage() {
    if (!chatMessages) return;
    
    const isSupport = currentUserIsSupport();
    
    if (isSupport) {
      addMessage("👋 Quick chat mode active. Select a user from the dropdown below.", 'bot');
    } else {
      addMessage("Hello! 👋 How can we help you today?", 'bot');
      addMessage("We typically reply within minutes", 'bot');
    }
  }

  function currentUserIsSupport() {
    return document.querySelector('meta[name="current-user-role"]')?.content === 'support' || 
           document.querySelector('meta[name="current-user-role"]')?.content === 'admin';
  }

  function addMessage(text, sender) {
    if (!chatMessages) return;

    const messageDiv = document.createElement('div');
    let bubbleClass = '';
    
    if (sender === 'other') {
      messageDiv.className = 'flex justify-start mb-2';
      bubbleClass = 'bg-gray-200 text-gray-800 rounded-lg rounded-bl-none p-3 max-w-xs text-sm';
    } else if (sender === 'user') {
      messageDiv.className = 'flex justify-end mb-2';
      bubbleClass = 'bg-green-600 text-white rounded-lg rounded-br-none p-3 max-w-xs text-sm';
    } else { // 'bot'
      messageDiv.className = 'flex justify-start mb-2';
      bubbleClass = 'bg-blue-100 text-blue-800 rounded-lg rounded-bl-none p-3 max-w-xs text-sm';
    }
    
    const bubble = document.createElement('div');
    bubble.className = bubbleClass;
    bubble.textContent = text;
    messageDiv.appendChild(bubble);
    
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
  }

  function addTypingIndicator() {
    if (!chatMessages) return document.createElement('div');

    const typingDiv = document.createElement('div');
    typingDiv.className = 'flex justify-start mb-2';
    
    const bubble = document.createElement('div');
    bubble.className = 'bg-gray-200 text-gray-800 rounded-lg rounded-bl-none p-3';
    bubble.innerHTML = `
      <div class="flex space-x-1">
        <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
        <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></div>
        <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></div>
      </div>
    `;
    
    typingDiv.appendChild(bubble);
    chatMessages.appendChild(typingDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
    
    return typingDiv;
  }

  // NEW FUNCTION: Update all unread badges
  function updateAllUnreadBadges() {
    // Only update if user is signed in
    const userId = document.querySelector('meta[name="current-user-id"]')?.content;
    if (!userId) return;
    const role = document.querySelector('meta[name="current-user-role"]')?.content;

    // Only support/admin can read /support/dashboard.json.
    if (role !== 'support' && role !== 'admin') return;
    
    fetch('/support/dashboard.json')
      .then(response => response.json())
      .then(data => {
        const totalUnread = data.total_unread_for_current_user || data.current_user_unread || 0;
        
        // Update toggle button badge
        const toggleBadge = document.getElementById('chat-toggle-badge');
        if (toggleBadge) {
          toggleBadge.textContent = totalUnread;
          if (totalUnread > 0) {
            toggleBadge.classList.remove('hidden');
            toggleBadge.classList.add('animate-pulse');
          } else {
            toggleBadge.classList.add('hidden');
            toggleBadge.classList.remove('animate-pulse');
          }
        }
        
        // Update header badge
        const headerBadge = document.getElementById('chat-header-badge');
        if (headerBadge) {
          headerBadge.textContent = totalUnread + ' unread';
          if (totalUnread > 0) {
            headerBadge.classList.remove('hidden');
          } else {
            headerBadge.classList.add('hidden');
          }
        }
        
        // Update user unread message
        const userUnreadMessage = document.getElementById('user-unread-message');
        if (userUnreadMessage) {
          if (totalUnread > 0) {
            userUnreadMessage.textContent = `You have ${totalUnread} unread message${totalUnread === 1 ? '' : 's'}`;
            userUnreadMessage.classList.remove('hidden');
          } else {
            userUnreadMessage.classList.add('hidden');
          }
        }
        
        // Update user dropdown
        const userSelect = document.getElementById('support-user-select');
        if (userSelect && data.unread_counts) {
          Array.from(userSelect.options).forEach(option => {
            if (option.value && data.unread_counts[option.value]) {
              const unreadCount = data.unread_counts[option.value];
              const name = option.text.split('(')[0].trim();
              if (unreadCount > 0) {
                option.text = `${name} (${unreadCount} unread)`;
                option.style.color = '#dc2626';
                option.style.fontWeight = '600';
              } else {
                option.text = name;
                option.style.color = '';
                option.style.fontWeight = '';
              }
            }
          });
        }
      })
      .catch(error => console.error('Error updating badges:', error));
  }

  // Close chat when clicking outside
  document.addEventListener('click', function(e) {
    if (chatBox && !chatBox.classList.contains('hidden') && 
        !chatBox.contains(e.target) && !chatToggle.contains(e.target)) {
      chatBox.classList.add('hidden');
    }
  });

  // Prevent chat widget clicks from closing the chat
  chatWidget.addEventListener('click', function(e) {
    e.stopPropagation();
  });

  // Initialize
  loadPosition();
  
  // Add welcome message on load
  setTimeout(() => {
    if (chatMessages && chatMessages.children.length === 0) {
      addWelcomeMessage();
    }
    
    // Initial badge update
    updateAllUnreadBadges();
  }, 500);
  
  // Periodic updates
  setInterval(updateAllUnreadBadges, 30000); // Every 30 seconds
  
  // Update when page becomes visible
  document.addEventListener('visibilitychange', function() {
    if (!document.hidden) {
      setTimeout(updateAllUnreadBadges, 1000);
    }
  });
}

document.addEventListener('DOMContentLoaded', initializeChatWidget);
document.addEventListener('turbo:load', initializeChatWidget);
if (document.readyState !== 'loading') {
  initializeChatWidget();
}

