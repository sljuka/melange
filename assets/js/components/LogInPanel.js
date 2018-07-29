// @flow

import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Header = styled.p`
  font-size: 1.5em;
`;

type Props = {
  onClick: () => void,
}

const LogInPanel = ({ onClick }: Props) => (
  <div>
    <Header>Have an account?</Header>
    <p>Welcome back, login here ;)</p>
    <button onClick={onClick}>
    Log in
    </button>
  </div>
);

LogInPanel.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default LogInPanel;
