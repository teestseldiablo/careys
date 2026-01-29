import React, { useState } from 'react';

const WorkTracker = ({ onSaveLog }) => {
  const [logData, setLogData] = useState({ note: '', cost: '', location: '' });
  const [isCapturing, setIsCapturing] = useState(false);

  const captureLocation = () => {
    setIsCapturing(true);
    navigator.geolocation.getCurrentPosition((pos) => {
      setLogData({...logData, location: `${pos.coords.latitude.toFixed(4)}, ${pos.coords.longitude.toFixed(4)}`});
      setIsCapturing(false);
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    // In a real app, you would POST to /api/expenses here
    onSaveLog(logData);
  };

  return (
    <div className="card" style={{ maxWidth: '600px', margin: '0 auto' }}>
      <h2 className="card-title">NEW MODERNIZATION ENTRY</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group" style={{marginBottom: '20px'}}>
          <label style={labelStyle}>INVESTMENT AMOUNT ($)</label>
          <input 
            type="number" 
            className="modern-input"
            placeholder="0.00"
            onChange={(e) => setLogData({...logData, cost: e.target.value})}
            required
            style={inputStyle}
          />
        </div>

        <div className="form-group" style={{marginBottom: '20px'}}>
          <label style={labelStyle}>MODERNIZATION NOTES</label>
          <textarea 
            className="modern-input"
            placeholder="Describe the upgrade or repair..."
            onChange={(e) => setLogData({...logData, note: e.target.value})}
            style={{...inputStyle, height: '100px'}}
          />
        </div>

        <button type="button" onClick={captureLocation} className="btn" style={geoButtonStyle}>
          {isCapturing ? '⌛ LOCALIZING...' : `📍 ${logData.location || 'ATTACH GPS COORDINATES'}`}
        </button>

        <button type="submit" className="btn btn-primary" style={{width: '100%', marginTop: '20px', height: '50px'}}>
          FINALIZE & SAVE TO LEDGER
        </button>
      </form>
    </div>
  );
};

const labelStyle = { display: 'block', fontSize: '10px', color: '#64748b', fontWeight: 'bold', marginBottom: '8px' };
const inputStyle = { width: '100%', padding: '12px', background: '#020617', border: '1px solid #1e293b', color: 'white', borderRadius: '4px' };
const geoButtonStyle = { background: 'rgba(59, 130, 246, 0.1)', color: '#3b82f6', border: '1px solid #3b82f6', width: '100%' };

export default WorkTracker;