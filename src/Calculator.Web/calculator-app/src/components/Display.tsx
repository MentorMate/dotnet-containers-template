import * as React from 'react';
import './Display.css';

interface PropTypes {
    value: string;
}

const Display: React.FC<PropTypes> = ({ value }) => (
  <div className="display">
    <div>{value}</div>
  </div>
);

export default Display;
