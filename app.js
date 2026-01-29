import React, { useState, useEffect } from 'react';
import Dashboard from './Dashboard';
import WorkTracker from './WorkTracker';

function App() {
  const [view, setView] = useState('dashboard');
  const [logs, setLogs] = useState([]);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState(null);

  // Fetch real data from the backend on load
  useEffect(() => {
    if (isAuthenticated) {
      fetch('/api/expenses')
        .then(res => res.json())
        .then(data => setLogs(data.success ? data.data : []))
        .catch(err => console.error("Error fetching logs:", err));
    }
  }, [isAuthenticated]);

  const handleLogin = async (pin) => {
    const response = await fetch('/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ pin })
    });
    const result = await response.json();
    if (result.success) {
      setUser(result.user);
      setIsAuthenticated(true);
    } else {
      alert("Invalid PIN");
    }
  };

  if (!isAuthenticated) {
    return <Login onLogin={handleLogin} />; // Use the login UI from your index.html
  }

  return (
    <div className="layout">
      {/* Fixed Sidebar from the video */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <h1 className="brand">CAREY'S</h1>
          <p style={{fontSize: '10px', color: 'var(--secondary)'}}>ENTERPRISE PORTAL</p>
        </div>
        <nav className="sidebar-nav">
          <button 
            className={`nav-item ${view === 'dashboard' ? 'active' : ''}`}
            onClick={() => setView('dashboard')}
          >
            📊 DASHBOARD
          </button>
          <button 
            className={`nav-item ${view === 'input' ? 'active' : ''}`}
            onClick={() => setView('input')}
          >
            ➕ NEW MODERNIZATION
          </button>
          <button className="nav-item">🏠 PROPERTY LIST</button>
          <button className="nav-item">👥 TENANT PORTAL</button>
          <button className="nav-item nav-logout" onClick={() => window.location.reload()}>
            🔒 LOGOUT
          </button>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="main">
        <div className="page">
          {view === 'dashboard' ? (
            <Dashboard logs={logs} />
          ) : (
            <WorkTracker onSaveLog={(newLog) => {
              setLogs([newLog, ...logs]);
              setView('dashboard');
            }} />
          )}
        </div>
      </main>
    </div>
  );
}

export default App;