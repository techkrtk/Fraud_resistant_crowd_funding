const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('Web3');
const compiledFactory = require('./build/CampaignFactory.json')

const provider = new HDWalletProvider(
   'hen worry fix bitter sport kite diagram egg buzz average absorb cargo' ,
   'https://rinkeby.infura.io/v3/7f33a80338c24901a7406f597f277d6b',

);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy for the account',accounts[0]);

   const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
        .deploy({data:'0x' + compiledFactory.bytecode})
        .send({gas:2000000 ,from: accounts[0]});

         
        console.log('Contract is deployed to', result.options.address); 
};
deploy();HDWalletProvider