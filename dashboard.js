import React from 'react';

const Dashboard = ({ logs }) => {
  return (
    <div style={styles.container}>
      <h2 style={{color: '#2c3e50'}}>Project Dashboard</h2>
      
      {/* Stats Row */}
      <div style={styles.statsRow}>
        <div style={styles.card}>
          <h4>Total Spent</h4>
          <p style={styles.statText}>${logs.reduce((acc, log) => acc + (parseFloat(log.cost) || 0), 0)}</p>
        </div>
        <div style={styles.card}>
          <h4>Photos</h4>
          <p style={styles.statText}>{logs.length}</p>
        </div>
      </div>

      <h3>Recent Activity</h3>
      <div style={styles.logList}>
        {logs.map((log, index) => (
          <div key={index} style={styles.logItem}>
            <strong>{new Date().toLocaleDateString()}</strong>: {log.note}
            {log.image && <p style={{fontSize: '12px', color: 'blue'}}>📎 Image Attached</p>}
            <p style={{fontSize: '11px', color: '#666'}}>📍 {log.location}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

const styles = {
  container: { padding: '15px', background: '#f4f7f6', minHeight: '100vh' },
  statsRow: { display: 'flex', gap: '10px', marginBottom: '20px' },
  card: { flex: 1, padding: '15px', background: '#fff', borderRadius: '10px', boxShadow: '0 2px 5px rgba(0,0,0,0.1)' },
  statText: { fontSize: '20px', fontWeight: 'bold', color: '#27ae60' },
  logList: { background: '#fff', borderRadius: '10px', padding: '10px' },
  logItem: { padding: '10px', borderBottom: '1px solid #eee' }
};

export default Dashboard;