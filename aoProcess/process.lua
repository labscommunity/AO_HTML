-- MEMEFRAMES
-- Version: 0.1.
-- NOTE: Requires token blueprint and staking blueprint to be loaded in order to run.

Votes = Votes or {}
BuyToken = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc"
MaxMint = 1000000
Minted = 0
FrameID = "vADWSIgQd8EpBjHgZTxii_ucwE6sndk12cCcEUoUXRk"
VoteLength = 30 * 24

Handlers.add(
  "Mint",
  function(m)
    return m.Action == "Credit-Notice" and m.From == BuyToken
  end,
  function(m)
    local requestedAmount = tonumber(m.Quantity)
    local actualAmount = requestedAmount
    if (Minted + requestedAmount) > MaxMint then
      actualAmount = (Minted + requestedAmount) - MaxMint
      Send({
        Target = BuyToken,
        Action = "Transfer",
        Recipient = m.From,
        Quantity = tostring(requestedAmount - actualAmount)
      })
    end
    local prevBalance = Balances[m.From] or 0
    Balances[m.From] = prevBalance + actualAmount
  end
)

Handlers.add(
  "Get-Frame",
  Handlers.utils.hasMatchingTag("Action", "Get-Frame"),
  function(m)
    ao.send({
      Target = m.From,
      Action = "Frame-Response",
      Frame = FrameID
    })
  end
)

-- Vote Action Handler
Handlers.vote = function(msg)
  local quantity = Stakers[msg.From].amount
  local ID = msg.TXID
  local side = msg.Tags.Side
  local command = msg.Tags.Command or ""
  local deadline = tonumber(msg['Block-Height']) + VoteLength
  assert(quantity > 0, "No staked tokens to vote")
  Votes[ID] = Votes[ID] or { yay = 0, nay = 0, deadline = deadline, command = command }
  Votes[ID][side] = Votes[ID][side] + quantity
end

-- Finalization Handler
Handlers.finalizationHandler = function(msg)
  local currentHeight = tonumber(msg['Block-Height'])
  -- Process voting
  for id, voteInfo in pairs(Votes) do
      if currentHeight >= voteInfo.deadline then
          if voteInfo.yay > voteInfo.nay then
              if voteInfo.command == "" then
                FrameID = voteInfo.ID
              else
                -- TODO: Test that command execution runs with the right scope?
                load(voteInfo.command)
              end
          end
          -- Clear the vote record after processing
          Votes[id] = nil
      end
  end
end

-- wrap function to continue handler flow
local function continue(fn)
  return function (msg)
    local result = fn(msg)
    if (result) == -1 then
      return 1
    end
    return result
  end
end

Handlers.add("vote",
  continue(Handlers.utils.hasMatchingTag("Action", "Vote")), Handlers.vote)
-- Finalization handler should be called for every message
Handlers.add("finalize", function (msg) return -1 end, Handlers.finalizationHandler)