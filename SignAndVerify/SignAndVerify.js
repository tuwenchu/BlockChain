const crypto = require('crypto');

// 生成公私钥对
const { privateKey, publicKey } = crypto.generateKeyPairSync('rsa', {
    modulusLength: 2048,
    publicKeyEncoding: {
        type: 'spki',
        format: 'pem'
    },
    privateKeyEncoding: {
        type: 'pkcs8',
        format: 'pem',
    }
});

console.log("生成的私钥：\n", privateKey);
console.log("生成的公钥：\n", publicKey);

// 待签名的数据
const data = "DZH63977";

// 使用私钥对数据进行签名
const sign = crypto.sign('sha256', Buffer.from(data), {
    key: privateKey,
    padding: crypto.constants.RSA_PKCS1_PSS_PADDING,
});

console.log("签名后的数据：\n", sign.toString('base64'));

// 使用公钥对签名进行验证
const isVerified = crypto.verify('sha256', Buffer.from(data), {
    key: publicKey,
    padding: crypto.constants.RSA_PKCS1_PSS_PADDING,
}, sign);

console.log("验证签名结果：", isVerified ? "通过" : "未通过");
