// @flow

import React, { type Node } from 'react';
import styled from 'styled-components';
import Team, { type TeamType } from './Team';

const Wrapper = styled.div`
  border: 1px solid #ccc;
`

const Content = styled.div`
  padding: 0 16px;
  background: ${props => props.theme.colors.background};
`

const Header = styled.div`
  border-bottom: 1px solid #ccc;
  padding: 8px 16px;
  font-size: 1.1em;
  background-color: ${props => props.theme.colors.secondary};
`

type PropsType = {
  children: Node,
  title: string,
}

const SimpleView = ({ children, title }: PropsType) => (
  <Wrapper>
    <Header>
      <span>{title}</span>
    </Header>
    <Content>
      {children}
    </Content>
  </Wrapper>
)

export default SimpleView;
