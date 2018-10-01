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

const RegisterForm = () => (
  <Container>
    <form>
      <FormGroup>
        <TextInput placeholder="Full name" />
      </FormGroup>
      <FormGroup>
        <TextInput placeholder="Email" />
      </FormGroup>
      <FormGroup>
        <TextInput placeholder="Username" />
      </FormGroup>
      <FormGroup>
        <TextInput type="password" placeholder="Password" />
      </FormGroup>
      <FormGroup>
        <Button onClick={(e) => e.preventDefault()}>Sign up</Button>
      </FormGroup>
    </form>
  </Container>
)

export default RegisterForm;
