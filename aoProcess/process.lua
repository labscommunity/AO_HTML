
-- process id 9yyPnCmMJjIZ3WcgS1NhL0mbT6JbEKxSfnVhkhwI6oM
-- .load process.lua
-- Send({ Target = "9yyPnCmMJjIZ3WcgS1NhL0mbT6JbEKxSfnVhkhwI6oM", Data = "getWebsite" })
-- Inbox[#Inbox].Data


Handlers.add(
  "getWebsite",
  Handlers.utils.hasMatchingData("getWebsite"),
  Handlers.utils.reply("vADWSIgQd8EpBjHgZTxii_ucwE6sndk12cCcEUoUXRk")
)

