import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Home from './pages/Home';

// 获取基础路径，处理生产环境的子路径
// 在生成应用时，这个值会被替换为实际的仓库名
const basename = import.meta.env.PROD ? '/TEMPLATE_NAME' : '';

function App() {
  return (
    <Router basename={basename}>
      <Layout>
        <Routes>
          <Route path="/" element={<Home />} />
          {/* 路由将基于提供的 HTML 文件自动生成 */}
        </Routes>
      </Layout>
    </Router>
  );
}

export default App;