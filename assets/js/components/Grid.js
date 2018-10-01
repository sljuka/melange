import React from 'react';
import styled from 'styled-components';

const Grid = styled.div`
  display: grid;
  gap: 5px;
  grid-template-columns: repeat(12, 1fr);
  grid-template-rows: repeat(12, 1fr);
`

export default Grid;
