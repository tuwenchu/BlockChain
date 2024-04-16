const crypto = require('crypto');

class Block {
    constructor(index, timestamp, data, previousHash = '') {
        this.index = index;
        this.timestamp = timestamp;
        this.data = data;
        this.previousHash = previousHash;
        this.hash = this.calculateHash();
        this.nonce = 0; // 用于POW的随机数
    }

    // 计算区块的哈希值
    calculateHash() {
        return crypto.createHash('sha256').update(this.index + this.timestamp + JSON.stringify(this.data) + this.previousHash + this.nonce).digest('hex');
    }

    // POW，挖矿
    mineBlock(difficulty) {
        while (this.hash.substring(0, difficulty) !== Array(difficulty + 1).join("0")) {
            this.nonce++;
            this.hash = this.calculateHash();
        }
        console.log(`Block mined: ${this.hash}`);
    }
}

class Blockchain {
    constructor() {
        this.chain = [this.createGenesisBlock()]; // 初始创建一个创世块
        this.difficulty = 4; // 难度值，以4个0开头
    }

    // 创建创世块
    createGenesisBlock() {
        return new Block(0, new Date().toISOString(), "Genesis Block", "0");
    }

    // 获取最新的区块
    getLatestBlock() {
        return this.chain[this.chain.length - 1];
    }

    // 添加新的区块
    addBlock(newBlock) {
        newBlock.previousHash = this.getLatestBlock().hash; // 设置新块的previousHash
        newBlock.mineBlock(this.difficulty); // 挖矿
        this.chain.push(newBlock); // 将新块添加到链上
    }

    // 检查区块链的有效性
    isValidChain() {
        for (let i = 1; i < this.chain.length; i++) {
            const currentBlock = this.chain[i];
            const previousBlock = this.chain[i - 1];

            // 检查当前块的哈希值是否正确
            if (currentBlock.hash !== currentBlock.calculateHash()) {
                return false;
            }

            // 检查当前块的previousHash是否等于前一个块的哈希值
            if (currentBlock.previousHash !== previousBlock.hash) {
                return false;
            }
        }
        return true;
    }
}

// 创建一个区块链
const blockchain = new Blockchain();

// 添加一些块
console.log("Mining block 1...");
blockchain.addBlock(new Block(1, new Date().toISOString(), { amount: 4 }));

console.log("Mining block 2...");
blockchain.addBlock(new Block(2, new Date().toISOString(), { amount: 8 }));

// 输出区块链
console.log(JSON.stringify(blockchain, null, 2));

// 检查区块链的有效性
console.log("Is blockchain valid? " + (blockchain.isValidChain() ? "Yes" : "No"));
