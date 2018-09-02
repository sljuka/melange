// @flow

import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

const Menu = styled.ul`
  display: flex;
  border: 1px solid #ccc;
  margin: 0;
  padding: 0;
  padding: 5px;
`

const MenuItem = styled.li`
  list-style: none;
  margin-right: 10px;
`

const Link = styled.span`
  text-decoration: none;
  color: #ccc;
`

const Navbar = () => (
  <Menu role="navigation">
    <MenuItem><Link href="#">Home</Link></MenuItem>
    <MenuItem><Link href="#">Processes</Link></MenuItem>
  </Menu>
);

export default Navbar;
