
require 'rails_helper'

RSpec.describe Aoeworld, type: :service do
  describe '.instance' do
    it 'returns a Aoeworld service instance' do
      expect(described_class.instance).to be_a(described_class)
    end
  end

  describe '#player' do
    context 'when the player id is informed' do
      context 'and the player exist' do
        it 'returns a hash containing the player information' do
          stub_request(
            :get,
            "https://aoe4world.com/api/v0/players/3904126"
          ).to_return(
            body: {
              name: "Hendrikson",
              profile_id: 3904126,
            }.to_json,
            status: 200
          )

          player_id = 3_904_126
          player_info = described_class.instance.player(player_id)

          expect(player_info).to include(
            "name" => "Hendrikson",
            "profile_id" => 3904126
          )
        end
      end

      context 'but the player does not exist' do
        it 'returns an empty hash' do
          stub_request(
            :get,
            "https://aoe4world.com/api/v0/players/111222"
          ).to_return(
            status: 404
          )

          player_id = 111_222
          player_info = described_class.instance.player(player_id)

          expect(player_info).to eq({})
        end
      end
    end

    context 'when the player id not informed' do
      it 'returns an empty hash' do
        player_id = 0
        player_info = described_class.instance.player(player_id)

        expect(player_info).to eq({})
      end
    end
  end

  describe '#players' do
    context 'when a valid name is informed' do
      it 'returns an array with the players that include that name' do
        stub_request(
          :get,
          "https://aoe4world.com/api/v0/players/search?query=Hendrikson"
        ).to_return(
          body: {
            total_count: 0,
            page: 1,
            per_page: 50,
            count: 0,
            offset: 0,
            filters: {
              query: "a weird name ",
              exact: false
            },
            players: [
              {
                name: "Hendrikson",
                profile_id: 3_904_126
              },
              {
                name: "Hendrikson auf Hawaiiiiiiiiiiiii",
                profile_id: 4_256_318
              }
            ]
          }.to_json,
          status: 200
        )

        player_name = 'Hendrikson'
        players = described_class.instance.players(player_name)

        expect(players).to eq([
          {
            "name" => "Hendrikson",
            "profile_id" => 3_904_126
          },
          {
            "name" => "Hendrikson auf Hawaiiiiiiiiiiiii",
            "profile_id" => 4_256_318
          }
        ])
      end
    end

    context 'when a invalid name is informed' do
      it 'returns an empty array' do
        stub_request(
          :get,
          "https://aoe4world.com/api/v0/players/search?query=an%20invalid%20name"
        ).to_return(
          body: {
            total_count: 0,
            page: 1,
            per_page: 50,
            count: 0,
            offset: 0,
            filters: {
              query: "a weird name ",
              exact: false
            },
            players: []
          }.to_json,
          status: 200
        )

        player_name = 'an invalid name'
        players = described_class.instance.players(player_name)

        expect(players).to eq([])
      end
    end
  end

  describe '#games' do
    context 'when there are games for the two players' do
      it 'returns an array with the games that include the two players' do
        stub_request(
          :get,
          "https://aoe4world.com/api/v0/players/3904126/games?opponent_profile_id=9577192"
        ).to_return(
          body: {
            total_count: 0,
            page: 1,
            per_page: 50,
            count: 0,
            offset: 0,
            filters: {
              leaderboard: nil,
              since: nil,
              profile_ids: [ 3_904_126 ],
              opponent_profile_id: "9577192",
              opponent_profile_ids: [ "9577192" ]
            },
            games: [
              {
                game_id: 122667065,
                started_at: "2024-04-11T23:36:35.000Z",
                teams: [
                  [
                    {
                      player: {
                        profile_id: 3_904_126,
                        name: "Hendrikson",
                        result: "win"
                      }
                    }
                  ],
                  [
                    {
                      player: {
                        profile_id: 9_577_192,
                        name: "The Oracle5419",
                        result: "loss"
                      }
                    }
                  ]
                ]
              }
            ]
          }.to_json,
          status: 200
        )

        player_id = 3_904_126
        opponent_id = 9_577_192
        games = described_class.instance.games(player_id: player_id, opponent_id: opponent_id)

        expect(games).to eq([
          {
            "game_id" => 122667065,
            "started_at" => "2024-04-11T23:36:35.000Z",
            "teams" => [
              [
                {
                  "player" => {
                    "profile_id" => 3_904_126,
                    "name" => "Hendrikson",
                    "result" => "win"
                  }
                }
              ],
              [
                {
                  "player" => {
                    "profile_id" => 9_577_192,
                    "name" => "The Oracle5419",
                    "result" => "loss"
                  }
                }
              ]
            ]
          }
        ])
      end
    end

    context 'when there are not games for the two players' do
      it 'returns an empty array' do
        stub_request(
          :get,
          "https://aoe4world.com/api/v0/players/111111/games?opponent_profile_id=999999"
        ).to_return(
          body: {
            total_count: 0,
            page: 1,
            per_page: 50,
            count: 0,
            offset: 0,
            filters: {
              leaderboard: nil,
              since: nil,
              profile_ids: [ 3_904_126 ],
              opponent_profile_id: "111111",
              opponent_profile_ids: [ "111111" ]
            },
            games: []
          }.to_json,
          status: 200
        )

        player_id = 111_111
        opponent_id = 999_999
        games = described_class.instance.games(player_id: player_id, opponent_id: opponent_id)

        expect(games).to eq([])
      end
    end
  end
end
