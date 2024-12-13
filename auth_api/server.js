const express = require("express");
const bodyParser = require("body-parser");
const authRoutes = require("./routes/authRoutes");
const cors = require("cors");
const { WebSocketServer } = require("ws");
const WebSocket = require("ws");

const app = express();
app.use(bodyParser.json());
app.use(cors());

app.use("/auth", authRoutes);
let _username = "";
app.post("/login", (req, res) => {
  const { username } = req.body;
  _username = username
  if (username) {
    return res.json({ success: true, token: `token_${username}` });
  }
  return res.status(400).json({ success: false, message: "Invalid username" });
});

const messages = [
  { sender: "user1", content: "user1 msg", timestamp: Date.now() - 10000 },
  { sender: "user2", content: "user2 msg", timestamp: Date.now() - 5000 },
];

const wss = new WebSocketServer({ port: 8081 });

wss.on("connection", (ws) => {
  console.log("Client connected");

  ws.send(JSON.stringify({ type: "history", messages }));

  ws.on("message", (data) => {
    try {
      const { sender, content } = JSON.parse(data);

      if (!sender || !content) {
        throw new Error("Invalid message structure");
      }

      const message = { sender, content, timestamp: Date.now() };
      messages.push(message);
      wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN && message.sender != _username) {
          client.send(
            JSON.stringify({ type: "message", message: message })
          );
        }
      });
      //simulateSecondParticipant(content);
    } catch (error) {
      console.error("Invalid message format:", error.message);
    }
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });
});

const simulateSecondParticipant = (userMessage) => {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify({ type: "typing", sender: "bot" }));
    }
  });

  const typingDelay = Math.floor(Math.random() * 5000) + 1000;

  setTimeout(() => {
    const botResponse = generateBotResponse(userMessage);

    const botMessage = {
      sender: "bot",
      content: botResponse,
      timestamp: Date.now(),
    };

    messages.push(botMessage);

    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify({ type: "message", message: botMessage }));
      }
    });
  }, typingDelay);
};

function generateBotResponse() {
  const responses = [
    "That sounds interesting!",
    "Could you explain more?",
    "I didn't quite catch that.",
    "Let's dive deeper into it.",
    "What do you think about this?",
    "Sounds great!",
    "Can you elaborate?",
    "I totally agree!",
    "That's an intriguing idea.",
    "Tell me more about it.",
  ];
  return responses[Math.floor(Math.random() * responses.length)];
}

const PORT = 3000;
app.listen(PORT, () =>
  console.log(`Server running on http://localhost:${PORT}`)
);
