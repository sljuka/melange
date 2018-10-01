import React from 'react';
import styled from 'styled-components';
import TextInput from '../components/TextInput';
import FormGroup from '../components/FormGroup';
import Button from '../components/Button';

const Container = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
`

const LoginForm = () => (
  <Container>
    <form>
      <FormGroup>
        <TextInput placeholder="Username or email" />
      </FormGroup>
      <FormGroup>
        <TextInput type="password" placeholder="Password" />
      </FormGroup>
      <FormGroup>
        <Button onClick={(e) => e.preventDefault()}>Log in</Button>
      </FormGroup>
    </form>
  </Container>
)

export default LoginForm;
