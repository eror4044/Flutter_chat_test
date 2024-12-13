const express = require("express");
const router = express.Router();
const authService = require("../services/authService");

router.post("/register", (req, res) => {
  const { username } = req.body;
  if (!username) {
    return res
      .status(400)
      .json({ success: false, message: "Username is required" });
  }
  const result = authService.registerUser(username);
  if (result.success) {
    return res.json(result);
  }
  return res.status(400).json(result);
});

router.post("/login", (req, res) => {
  console.log("lohin");
  
  const { username } = req.body;
  if (!username) {
    return res
      .status(400)
      .json({ success: false, message: "Username is required" });
  }
  const result = authService.loginUser(username);
  if (result.success) {
    return res.json(result);
  }
  return res.status(401).json(result);
});

router.post("/validate", (req, res) => {
  const { token } = req.body;
  if (!token) {
    return res
      .status(400)
      .json({ success: false, message: "Token is required" });
  }
  const isValid = authService.validateToken(token);
  return res.json({ success: isValid });
});

module.exports = router;
