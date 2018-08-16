import React from 'react';
import TextInput from '../components/TextInput';
import FormGroup from '../components/FormGroup';
import Button from '../components/Button';

const LoginForm = () => (
  <form>
    <FormGroup>
      <TextInput placeholder="username or email" />
    </FormGroup>
    <FormGroup>
      <TextInput type="password" placeholder="password" />
    </FormGroup>
    <FormGroup>
      <Button onClick={(e) => e.preventDefault()}>Submit</Button>
    </FormGroup>
  </form>
)

export default LoginForm;
