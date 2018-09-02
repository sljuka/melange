import React from 'react';
import TextInput from '../components/TextInput';
import FormGroup from '../components/FormGroup';
import Button from '../components/Button';

const LoginForm = () => (
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
)

export default LoginForm;
