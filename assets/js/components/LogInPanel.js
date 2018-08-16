// @flow

import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Button from '../components/Button';

const Header = styled.p`
  font-size: 1.5em;
`;

type Props = {
  selectPanel: () => void,
}

const LogInPanel = ({ selectPanel }: Props) => (
  <div>
    <Header>Have an account?</Header>
    <p>Welcome back</p>
    <Button onClick={selectPanel}>Log in</Button>
  </div>
);

LogInPanel.propTypes = {
  onClick: PropTypes.func.isRequired,
};

export default LogInPanel;
