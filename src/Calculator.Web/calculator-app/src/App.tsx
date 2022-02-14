import * as React from 'react';
import { useEffect, useState, useCallback } from 'react';

import Display from './components/Display';
import ButtonPanel from './components/ButtonPanel';
import { AppState, calculate, emptyState, getState, saveState } from './logic/calculate';

import './App.css';

const App: React.FC = () => {
  const [state, setState] = useState<AppState>(emptyState);

  // load state function.
  const loadState = useCallback(async () => {
    const savedState = await getState();
    if (savedState) {
      console.debug('Rehydrating State:', JSON.stringify(savedState));
      setState(savedState);
    }
  }, []);

  // onInit();
  useEffect(() => {
    loadState();
  }, [loadState]);

  const handleClick = useCallback(async (buttonName) => {
    const newState = await calculate(state, buttonName);
    setState(newState);
    saveState(newState);
  }, [state, setState]);

  return (
    <div className="app">
      <Display value={state.next || state.total || "0"} />
      <ButtonPanel clickHandler={handleClick} />
    </div>
  );
};

export default App;
