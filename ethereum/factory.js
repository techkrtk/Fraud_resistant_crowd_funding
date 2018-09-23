import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),
    '0x072fDaC582e38E54Aa4Da3943f1f03bD68C02475'
);

export default instance;