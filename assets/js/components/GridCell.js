import React from 'react';
import styled from 'styled-components';

const Grid = styled.div`
  grid-area: ${props => props.default.area};
  @media (max-width: 770px) {
    grid-area: ${props => props.tablet ? props.tablet.area : props.default.area};
  }
  @media (max-width: 670px) {
    grid-area: ${props => {
      const media = props.mobile || props.tablet || props.default
      return media.area;
    }}
  }
`

export default Grid;
