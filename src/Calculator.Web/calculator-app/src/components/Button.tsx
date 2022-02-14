import * as React from 'react';
import { useCallback } from 'react';
import './Button.css';

interface PropTypes {
  name: string;
  orange?: boolean;
  wide?: boolean;
  clickHandler: (name: string) => void;
}

const Button: React.FC<PropTypes> = ({ name, orange, wide, clickHandler }) => {
  const clickHandle = useCallback(() => clickHandler(name), [name, clickHandler]);
  const className = [
    "button",
    orange ? "orange" : "",
    wide ? "wide" : "",
  ];

  return (
    <div className={className.join(" ").trim()}>
      <button aria-label={name} onClick={clickHandle}>{name}</button>
    </div>
  );
}

export default Button;
