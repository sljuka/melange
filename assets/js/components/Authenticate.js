import React from 'react';
import styled from 'styled-components';
import MediaQuery from 'react-responsive';
import HoverPanel from '../components/HoverPanel';
import LoginPanel from '../components/LogInPanel';
import SignUpForm from '../components/SignUpForm';
import SignUpPanel from '../components/SignUpPanel';
import LoginForm from '../components/LoginForm';
import AuthPanel from '../components/AuthPanel';

const Container = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
`

const Authenticate = () => (
  <Container>
    <MediaQuery minWidth={571}>
      <HoverPanel
        FirstPanel={LoginPanel}
        SecondPanel={SignUpPanel}
        FirstHoverPanel={LoginForm}
        SecondHoverPanel={SignUpForm}
      />
    </MediaQuery>
    <MediaQuery maxWidth={570}>
      <AuthPanel />
    </MediaQuery>
  </Container>
)

export default Authenticate;
