import React, { Fragment } from 'react';
import { withState, compose, withHandlers } from 'recompose';
import LoginForm from '../components/LoginForm';
import SignUpForm from '../components/SignUpForm';
import Button from '../components/Button';

const AuthPanel = ({ loginPanelSelected, selectLoginPanel, selectSignUpPanel}) => (
  <div>
    {loginPanelSelected && (
      <Fragment>
        <LoginForm />
        <Button type="link" onClick={selectSignUpPanel}>or Sign up</Button>
      </Fragment>
    )}
    {!loginPanelSelected && (
      <Fragment>
        <SignUpForm />
        <Button type="link" onClick={selectLoginPanel}>or Log in</Button>
      </Fragment>
    )}
  </div>
)

export default compose(
  withState('loginPanelSelected', 'setLoginPanelSelected', true),
  withHandlers({
    selectLoginPanel: ({ setLoginPanelSelected }) => () => setLoginPanelSelected(true),
    selectSignUpPanel: ({ setLoginPanelSelected }) => () => setLoginPanelSelected(false),
  })
)(AuthPanel);
