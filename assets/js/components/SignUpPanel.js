import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Button from '../components/Button';

const Header = styled.p`
  font-size: 1.5em;
`;

const SignUpPanel = ({ selectPanel }) => (
  <div>
    <Header>No account?</Header>
    <p>NP, signup for an account!</p>
    <Button onClick={selectPanel}>Sign up</Button>
  </div>
);

SignUpPanel.propTypes = {
  selectPanel: PropTypes.func.isRequired,
};

export default SignUpPanel;
