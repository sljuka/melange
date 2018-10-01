// @flow

import React from 'react';
import styled from 'styled-components';

export default styled.div`
  width: 70%;
  margin: auto;

  @media (max-width: 769px) {
    width: 90%
  }

  @media (max-width: 700px) {
    width: auto;
  }
`;
