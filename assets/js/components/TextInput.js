import React from 'react';
import styled from 'styled-components';

const TextInput = styled.input.attrs({
  type: 'text',
})`
  margin: 0;
  display: block;
  width: auto;
  padding: .375rem .75rem;
  font-size: 1rem;
  line-height: 1.5;
  background-color: #fff;
  background-clip: padding-box;
  border: 1px solid #ced4da;
  border-radius: .25rem;
`

export default TextInput;
