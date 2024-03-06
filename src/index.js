import { connect } from "@permaweb/aoconnect";

const { dryrun } = connect({
  MU_URL: "https://ao-mu-1.onrender.com",
  CU_URL: "https://ao-cu-1.onrender.com",
  GATEWAY_URL: "https://g8way.io",
});

async function getWebsite(processId) {
  const result = await dryrun({
    process: processId,
    data: 'Get-Frame',  
  });
  console.log(result)
  return result.Messages[0]
}


(async () => {
  const processId = 'xCbRW3GKUqkTs2dPfTbE-09x4zbYqh6FaiUfaBo0TB0';
  const processResponse = await getWebsite(processId);

  console.log(processResponse)

  const website = await fetch(`https://arweave.net/${processResponse.Data}/data`)
  const websiteData = await website.text();

  document.getElementById('body').innerHTML = websiteData;
})();

