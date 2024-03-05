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



const resultBox = document.getElementById('body')
resultBox.textContent = 123;
