import { connect } from "@permaweb/aoconnect";


const { spawn, message, results } = connect({
  MU_URL: "https://ao-mu-1.onrender.com",
  CU_URL: "https://ao-cu-1.onrender.com",
  GATEWAY_URL: "https://g8way.io",
});


async function getResult(messageId, processId) {
  const { Output, Messages, Spawns, Error } = await results({
    message: messageId,
    process: processId,
  });

  return { Output, Messages, Spawns, Error }
}


const processId = '9yyPnCmMJjIZ3WcgS1NhL0mbT6JbEKxSfnVhkhwI6oM'
const processResponse = await getResult('9yyPnCmMJjIZ3WcgS1NhL0mbT6JbEKxSfnVhkhwI6oM', processId)
console.log(processResponse)

const resultBox = document.getElementById('body')
resultBox.textContent = 123;
