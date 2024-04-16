const crypto = require('crypto');

// 定义你的昵称
const nickname = "DZH";

// 定义难度目标，即要求的前导零个数
const targetDifficulty1 = 4;
const targetDifficulty2 = 5;

// 找到满足指定难度目标的哈希值及对应的nonce和花费时间
function findHashWithDifficulty(difficulty) {
    let nonce = 0;
    const startTime = new Date().getTime();

    while (true) {
        const data = nickname + nonce;
        const hash = crypto.createHash('sha256').update(data).digest('hex');
        if (hash.startsWith('0'.repeat(difficulty))) {
            const endTime = new Date().getTime();
            const timeTaken = (endTime - startTime) / 1000;
            console.log(`找到满足${difficulty}个0的哈希值：${hash}`);
            console.log(`对应的nonce：${nonce}`);
            console.log(`花费时间：${timeTaken} 秒\n`);
            break;
        }
        nonce++;
    }
}

// 找到满足4个0开头的哈希值
findHashWithDifficulty(targetDifficulty1);

// 找到满足5个0开头的哈希值
findHashWithDifficulty(targetDifficulty2);