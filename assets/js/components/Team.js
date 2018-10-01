// @flow

import React from 'react';
import styled from 'styled-components';
import { compose, withHandlers } from 'recompose';

export type TeamType = {
  name: string,
  id: number,
}

type ComposeType = {
  team: TeamType,
  selectTeam: (number) => void,
}

type PropsType = {
  team: TeamType,
  onClick: () => void,
}

const ListItem = styled.li`
  padding: 8px 0;
  cursor: pointer;
  color: ${props => props.theme.colors.linkBlue};
  &:hover {
    text-decoration: underline;
  }
`
const Team = ({ team, onClick }: PropsType) => (
  <ListItem onClick={onClick}>{team.name}</ListItem>
)

export default compose(
  withHandlers({
    onClick: ({ team: { id }, selectTeam }: ComposeType) => () => selectTeam(id)
  })
)(Team);
