// @flow

import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const NAVBAR_PADDING = 15;

const Menu = styled.ul`
  display: flex;
  border: 1px solid #ccc;
  margin: 0;
  padding: ${NAVBAR_PADDING}px;
  height: calc(100% - ${NAVBAR_PADDING * 2}px);
  background: ${props => props.theme.colors.primaryDark};
  border: none;
  color: ${props => props.theme.colors.blue};
`

const MenuItem = styled.li`
  list-style: none;
  margin-right: 10px;
`

const Link = styled.span`
  text-decoration: none;
`

const Navbar = () => (
  <Menu role="navigation">
    <MenuItem><Link href="#">Home</Link></MenuItem>
    <MenuItem><Link href="#">Processes</Link></MenuItem>
  </Menu>
);

export default Navbar;
