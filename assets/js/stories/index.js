import React from 'react';
import { storiesOf } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import HoverPanel from '../components/HoverPanel';
import Provider from 'react-redux';
import LoginPanel from '../components/LogInPanel';
import SignUpPanel from '../components/SignUpPanel';
import Progress from '../components/Progress';
import LoginForm from '../components/LoginForm';
import SignUpForm from '../components/SignUpForm';
import Container from '../components/Container';
import Navbar from '../components/Navbar'

const ContainerDecorator = (storyFn) => (
  <Container>
    { storyFn() }
  </Container>
);

storiesOf('Button', module)
  .addDecorator(ContainerDecorator)
  .add('with text', () => (
    <button onClick={action('clicked')}>Hello Button</button>
  ))
  .add('with some emoji', () => (
    <button onClick={action('clicked')}><span role="img" aria-label="so cool">😀 😎 👍 💯</span></button>
  ))
  .add('Hover panel', () => (
    <HoverPanel
      FirstPanel={LoginPanel}
      SecondPanel={SignUpPanel}
      FirstHoverPanel={LoginForm}
      SecondHoverPanel={SignUpForm}
    />
  ))
  .add('Navbar', () => (
    <Navbar />
  ))
