import React from 'react';
import { storiesOf } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import HoverPanel from '../components/HoverPanel';
import Provider from 'react-redux';
import LoginPanel from '../components/LogInPanel';
import SignUpPanel from '../components/SignUpPanel';

storiesOf('Button', module)
  .add('with text', () => (
    <button onClick={action('clicked')}>Hello Button</button>
  ))
  .add('with some emoji', () => (
    <button onClick={action('clicked')}><span role="img" aria-label="so cool">😀 😎 👍 💯</span></button>
  ))
  .add('Hover panel', () => {
    const LeftPanel = ({ selectPanel }) => (
      <div>
        <h2>Test 1</h2>
        <p>test 1</p>
        <button onClick={selectPanel}>
          TEST 1
        </button>
      </div>
    )

    return (
      <HoverPanel
        LeftPanel={LeftPanel}
        RightPanel={SignUpPanel}
        LeftHoverPanel={() => <span>Test1</span>}
        RightHoverPanel={() => <span>Test2</span>}
      />
    )
  })
