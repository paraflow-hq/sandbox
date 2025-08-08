interface LayoutProps {
  children: React.ReactNode;
}

const Layout: React.FC<LayoutProps> = ({ children }) => {
  return (
    <div className="min-h-screen">
      {/* 布局将基于提供的 HTML 文件结构自动生成 */}
      {children}
    </div>
  );
};

export default Layout;