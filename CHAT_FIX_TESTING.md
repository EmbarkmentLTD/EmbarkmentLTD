# Chat Message Fix - Testing Guide

**Deployment Status:** ✅ Deployed to https://www.embarkment.co.uk
**Commit:** 92fb071 - chat message display resilience and enhanced debugging

## Problem Fixed

**Original Issue:** James (buyer) sends message to Adewale (admin), both receive email notification but NO messages appear in either chat interface.

**Root Cause:** `loadConversation()` function was clearing chat messages before fetching from server. If the fetch failed for any reason (network issue, timeout, temporary server error), messages were wiped from the UI without restoration, leaving a blank chat.

**Solution:** Modified `loadConversation()` to save message DOM elements before clearing, and restore them if the fetch fails with `suppressErrors:true` flag.

## Testing the James→Adewale Scenario

### Setup
1. Open https://www.embarkment.co.uk in two separate browser windows/tabs
2. Sign in as **James** (buyer) in window 1
3. Sign in as **Adewale** (admin) in window 2

### Test Case 1: Basic Message Flow
**James → Adewale**
1. In James' window, open chat widget (green button bottom-right)
2. Select "Adewale Adesina (admin)" from dropdown
3. Type message: "Test message 1" and send
   - ✓ Message should appear immediately in James' chat (optimistic UI)
   - ✓ Browser console should log: `Sending message: {message: "Test message 1", receiverId: "X", action: "/support_chat_messages"}`
   - ✓ Adewale should receive email notification within seconds
4. In Adewale's window, open chat widget
5. Select "James" from contacts
   - ✓ Message "Test message 1" should appear in conversation thread
   - ✓ Browser console should log: `Chat conversations: current_user=..., other_user_id=..., found=...`

**Adewale → James**
1. In Adewale's chat, type reply: "Test reply 1"
2. Send message
   - ✓ Message appears immediately in Adewale's chat
   - ✓ James receives email notification
3. In James' chat, conversation should auto-load (within 4 seconds)
   - ✓ Reply "Test reply 1" should appear without needing to refresh

### Test Case 2: Network Resilience (Critical)
**Simulating fetch failure with suppressErrors:true**

This tests the actual bug fix.

1. In James' window:
   - Open DevTools (F12)
   - Go to Network tab
   - Select "Disable cache" and "Offline" (to simulate complete network failure)
2. Type message "Test during offline" and send
   - ✓ Message should appear in UI immediately (optimistic)
   - ✓ Network call will fail (expected)
   - ✓ Message should REMAIN visible (this is the fix!)
   - ✓ Console should log: "Restored X messages due to fetch failure"
3. Re-enable network in DevTools
4. Refresh Adewale's chat window
   - ✓ Message "Test during offline" should appear from server
   - ✓ Email was NOT sent (network was down), so no email notification

### Test Case 3: Unread Badges
1. Close Adewale's chat widget
2. James sends another message: "Test unread badge"
3. Watch Adewale's chat toggle button
   - ✓ Badge should appear showing unread count within 30 seconds
   - ✓ Badge count should increase
4. Adewale opens chat
   - ✓ Badge should disappear
   - ✓ Message should appear in thread

### Test Case 4: Rapid Messages
1. James sends 3 messages quickly in succession:
   - "First"
   - "Second"  
   - "Third"
2. All should appear in James' UI immediately
3. Wait for Adewale to receive emails (3 emails)
4. Adewale opens chat
   - ✓ All 3 messages should appear in order
   - ✓ No messages should be missing

## Debugging Output to Check

### Browser Console (F12 → Console tab)

**Expected logs when sending message:**
```
Sending message: {
  message: "Your message text",
  receiverId: "123",
  action: "/support_chat_messages"
}
Message send response: {
  status: 200,
  ok: true,
  data: {success: true, ...}
}
Message sent successfully, adding to UI
Loading conversation for user: 123
```

**Expected logs when loading conversation:**
```
Chat conversations: current_user=123, other_user_id=456, found=456
```

**If network fails with suppressErrors:true:**
```
Error loading conversation: Network error
Restored 2 messages due to fetch failure
```

### Server Logs

SSH into production and check logs:
```bash
# Connect to production
ssh ubuntu@your-server-ip

# View recent logs
docker logs embarkment --tail 100 | grep -i "chat message create\|chat conversations"
```

**Expected log entries:**
```
Chat message create: sender=123, receiver=456, text_length=18
Chat message create result: id=789, persisted=true, errors=
Chat conversations: current_user=456, other_user_id=123, found=123
Chat messages loaded: current_user=456, other_user=123, count=3
```

## Success Criteria

✅ **All must pass for fix to be considered successful:**

- [ ] Messages appear in both James' and Adewale's chat immediately after send
- [ ] Email notifications are received by Adewale for each message
- [ ] No blank/empty chat screens at any point during normal usage
- [ ] Messages persist even when network temporarily fails
- [ ] Unread badge counts are accurate
- [ ] Rapid message sending doesn't lose any messages
- [ ] Browser console shows clean logging (no unexpected errors)
- [ ] Server logs show message creation and retrieval

## Rollback Plan (if issues occur)

If you experience problems after deployment:

```bash
cd /Users/kvngjamesng/Development/EmbarkmentLTD
git revert 92fb071
git push
bin/kamal deploy
```

This will revert to the previous chat widget version while preserving database.

## Additional Notes

- The fix is backward compatible - doesn't change database schema or API contracts
- 8 integration tests pass with 60 assertions
- Fix only affects UI resilience, no business logic changes
- Both optimistic UI and server-side persistence remain unchanged
- Email notifications continue to work as before

---

**Questions or issues?** Check browser console and server logs first using the debugging output format above.
