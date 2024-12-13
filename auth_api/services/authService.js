const users = new Map([{ user: "user" }]);
const tokens = new Set();

const generateToken = (username) => `token_${username}_${Date.now()}`;

const registerUser = (username) => {
  if (users.has(username)) {
    return { success: false, message: "Username already exists" };
  }
  users.set(username, { username });
  return { success: true, message: "User registered successfully" };
};

const loginUser = (username) => {
  if (!users.has(username)) {
    return { success: false, message: "User not found" };
  }
  const token = generateToken(username);
  tokens.add(token);
  return { success: true, token, message: "Login successful" };
};

const validateToken = (token) => {
  return tokens.has(token);
};

module.exports = {
  registerUser,
  loginUser,
  validateToken,
};
