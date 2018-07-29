import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Header = styled.p`
  font-size: 1.5em;
`;

const SignUpPanel = ({ onClick }) => (
  <div>
    <Header>Don&apos;t have an account?</Header>
    <p>Signup by clicking here</p>
    <button onClick={onClick}>
    Sign up
    </button>
  </div>
);

SignUpPanel.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default SignUpPanel;
