import React from 'react';
import styled from 'styled-components';

const Button = ({ type, ...props }) => {
  switch(type) {
    case 'link': return <LinkButton {...props} />;
    default: return <ButtonBase {...props} />;
  }
}

const ButtonBase = styled.button`
  display: inline-block;
  font-weight: 400;
  text-align: center;
  white-space: nowrap;
  vertical-align: middle;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  border: 1px solid transparent;
  padding: .375rem .75rem;
  font-size: 1rem;
  line-height: 1.5;
  border-radius: .25rem;
  background-color: green;
  border-color: green;
  color: white;
`

const LinkButton = styled(ButtonBase)`
  background-color: transparent;
  color: #007bff;
  font-weight: 400;
  border: none;
`

export default Button;
