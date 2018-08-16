import React from 'react';
import TextInput from '../components/TextInput';
import FormGroup from '../components/FormGroup';
import Button from '../components/Button';

const RegisterForm = () => (
  <form>
    <FormGroup>
      <TextInput placeholder="email" />
    </FormGroup>
    <FormGroup>
      <TextInput placeholder="name" />
    </FormGroup>
    <FormGroup>
      <TextInput placeholder="username" />
    </FormGroup>
    <FormGroup>
      <TextInput type="password" placeholder="password" />
    </FormGroup>
    <FormGroup>
      <Button onClick={(e) => e.preventDefault()}>Submit</Button>
    </FormGroup>
  </form>
)

export default RegisterForm;
