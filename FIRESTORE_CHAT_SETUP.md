# Firestore chat integration

The iOS chat transport now uses Cloud Firestore. Existing host and guest chat
screens keep their current UI and behaviour, while both resolve a conversation
to one deterministic channel ID:

```text
Zyvoo_<lexicographically-smaller-user-id>_<lexicographically-larger-user-id>
```

This creates one direct conversation for the same host/guest pair, independent
of a booking or property ID, so the conversation can start before booking.

## Firestore shape

```text
chat_channels/{channelName}
  participant_ids: [String]
  last_message, last_message_id, last_sender_id
  last_message_at, last_media_url, updated_at

chat_channels/{channelName}/messages/{messageId}
  sender_id, type, text, media_type, media_url, file_name, created_at

chat_channels/{channelName}/members/{encodedUserId}
  user_id, unread_count, last_read_at, typing_until, last_active_at

chat_presence/{encodedUserId}
  user_id, active_until, last_seen_at
```

## Backend image/file upload

Firestore stores the backend URL, not the binary file. Configure the upload
closure once after login (or call the URL overload directly):

```swift
FirebaseChatManager.shared.backendMediaUploader = { data, contentType, fileName, completion in
    Backend.shared.uploadChatFile(
        data: data,
        contentType: contentType,
        fileName: fileName
    ) { result in
        completion(result) // Result<URL, Error>
    }
}
```

If the existing upload flow already returns a URL, send it without converting
it back to data:

```swift
FirebaseChatManager.shared.sendMediaMessage(
    mediaURL: uploadedURL,
    contentType: "image/jpeg",
    fileName: "chat-image.jpg"
) { result, message in
    // Preserve the existing success/error UI here.
}
```

## Security requirement

The app currently identifies a user with its backend user ID, but the user has
confirmed that Firebase Authentication/custom tokens are not used. Firestore
Security Rules therefore cannot securely prove that the caller owns that user
ID. Do not deploy public read/write rules for production.

Before production release, use one of these approaches:

1. Have the backend mint a Firebase custom token after normal app login, then
   restrict channel access to authenticated participant IDs in Firestore Rules.
2. Put Firestore chat reads/writes behind the authenticated backend and do not
   allow direct client access.

Firebase App Check is useful as an additional abuse-control layer, but it does
not replace per-user authentication or authorization.

## Migration scope

The transport and new channel naming are migrated. Existing Twilio conversation
history is not automatically copied; a separate server-side export/import is
required if old messages must remain visible.
