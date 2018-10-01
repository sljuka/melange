// @flow

import React from 'react';
import styled from 'styled-components';
import Team, { type TeamType } from './Team';
import SimpleView from './SimpleView';

const Wrapper = styled.div`
  border: 1px solid #ccc;
  min-width: 200px;
`

const List = styled.ul`
  list-style: none;
  margin: 0;
  padding: 0;
`

const Header = styled.div`
  border-bottom: 1px solid #ccc;
  padding: 8px 16px;
  font-size: 1.1em;
  background-color: ${props => props.theme.colors.blue};
`

type PropsType = {
  teams: Array<TeamType>,
  selectTeam: (number) => void,
}

const TeamsView = ({ teams, selectTeam }: PropsType) => (
  <SimpleView title="My teams">
    <List>
      {teams.map(team => (
        <Team key={team.id} selectTeam={selectTeam} team={team} />
      ))}
    </List>
  </SimpleView>
)

export default TeamsView;
