import Web3 from 'web3';

let web3;

if(typeof window !== 'undefined' && typeof window.web3 !== 'undefined') { 
    //We are in browser and metamask is running.
    web3 = new Web3(window.web3.currentProvider);

} else {
    //We are on the server *OR* the user is not running metamask.
    //Below code creates a custom provider.
    const provider = new Web3.providers.HttpProvider(
        'https://rinkeby.infura.io/v3/7f33a80338c24901a7406f597f277d6b'    
        );
        web3 = new Web3(provider);
}

export default web3;