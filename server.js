const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// 静态文件服务
app.use(express.static(path.join(__dirname, 'html')));

// 所有路由返回 index.html（SPA 兼容）
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'html', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🌐 服务器运行于 http://0.0.0.0:${PORT}`);
    console.log(`📁 静态目录: ${path.join(__dirname, 'html')}`);
    console.log(`🔧 环境: ${process.env.NODE_ENV || 'development'}`);
});
