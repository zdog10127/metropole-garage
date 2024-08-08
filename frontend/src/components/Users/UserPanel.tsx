import React, { useState } from 'react';
import "./UserPanel.css"

interface UserPanelProps {
    setUser: (user: string) => void;
    setPlate: (plate: string) => void;
}

const UserPanel: React.FC<UserPanelProps> = ({ setUser, setPlate }) => {
    const [isAdmSwitchOn, setIsAdmSwitchOn] = useState<boolean>(true);

    const handleChangeInput = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (!isAdmSwitchOn) {
            setUser(e.target.value);
        } else {
            setPlate(e.target.value);
        }
    };

    const handleChangeSwitch = () => {
        if (isAdmSwitchOn) {
            setUser("");
        } else {
            setUser("admin");
            setPlate("");
        }
        setIsAdmSwitchOn(!isAdmSwitchOn)
    }

    return (
        <div className="user-panel">
            <div className="user-card">
                <div>
                    <h3>Usuário</h3>
                </div>
                <label className="switch">
                    <input
                        type="checkbox"
                        checked={isAdmSwitchOn}
                        onChange={handleChangeSwitch}
                    />
                    <span className="slider"></span>
                </label>
                <div>
                    <h3>ADM</h3>
                </div>
            </div>
            <div >
                {isAdmSwitchOn ? (
                    <input
                        type="text"
                        placeholder="Placa"
                        className="search-input"
                        onChange={handleChangeInput}
                    />
                ) : (
                    <input
                        type="text"
                        placeholder="Steam"
                        className="search-input"
                        onChange={handleChangeInput}
                    />
                )}
            </div>
        </div>
    );
};

export default UserPanel;
