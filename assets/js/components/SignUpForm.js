import React from 'react';
import TextInput from '../components/TextInput';
import FormGroup from '../components/FormGroup';
import Button from '../components/Button';

const RegisterForm = () => (
  <form>
    <FormGroup>
      <TextInput placeholder="Email" />
    </FormGroup>
    <FormGroup>
      <TextInput placeholder="Name" />
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
)

export default RegisterForm;
