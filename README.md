# Real-Time Chat Application

This is a simplified real-time messaging mobile application built with Flutter. The project is designed to demonstrate integration with an internal API, real-time WebSocket communication, and adherence to clean architecture principles.

---

## Requirements

### Functional Requirements
1. **Login Screen**:
   - Accepts a username as input.
   - Transitions to the chat screen after successful login.

2. **Chat Screen**:
   - Displays a list of messages.
   - Includes a text input field for sending messages.
   - Automatically updates the chat window when new messages are received.

3. **Real-Time Messaging**:
   - Implements WebSocket for real-time message exchange.
   - Chat automatically refreshes when a new message is received.

4. **Backend Integration**:
   - Simulates or connects to an internal system using APIs or WebSocket.
     - Login API: `POST /login`
       - Input: `{ "username": "your_username" }`
       - Response: `{ "success": true, "token": "auth_token" }`
     - WebSocket Endpoint: `ws://example.com/chat`.

5. **Performance**:
   - Ensures smooth UI performance even with multiple messages.
   - Optimized rendering and state management.

6. **Clean Architecture**:
   - Code is organized into layers: Presentation, Domain, and Data.
   - Includes repository and service layers for API and WebSocket communication.

---

## Application Features

### Login
- Allows users to enter their username.
- Authenticates via the backend API and transitions to the chat screen.

### Chat
- Displays chat messages in a scrollable list.
- Includes a typing indicator when another participant is typing.
- Supports real-time updates through WebSocket communication.

### Real-Time Updates
- Automatically receives new messages and updates the UI.
- Reconnects on WebSocket disconnection.

### Backend
- Mock backend server or WebSocket simulation available for testing:
  - **Login API**: Handles authentication and returns a token.
  - **WebSocket Server**: Manages real-time message broadcasting.

---

## Setup and Installation

### Prerequisites
1. **Flutter SDK**: Version 3.x or later.
2. **Backend Server**: A WebSocket server for message handling.

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repository/chat-app.git
   cd chat-app
