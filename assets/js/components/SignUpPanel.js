import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Header = styled.p`
  font-size: 1.5em;
`;

const SignUpPanel = ({ selectPanel }) => (
  <div>
    <Header>No account?</Header>
    <p>NP, signup for an account!</p>
    <button onClick={selectPanel}>
    Sign up
    </button>
  </div>
);

SignUpPanel.propTypes = {
  selectPanel: PropTypes.func.isRequired,
};

export default SignUpPanel;
