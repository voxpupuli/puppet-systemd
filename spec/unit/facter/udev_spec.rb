# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a named device' do
  it do
    expect(fact.value).to include(
      'name' => include(
        name => dev
      )
    )
  end
end

shared_examples 'a path device' do
  it do
    expect(fact.value).to include(
      'path' => include(
        path => dev
      )
    )
  end
end

describe 'udev fact', type: :fact do
  subject(:fact) { Facter.fact(:udev) }

  before do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return(kernel)
  end

  context 'when kernel is Linux' do
    let(:kernel) { 'Linux' }

    context 'when udevadm is present' do
      before do
        allow(Facter.fact(:udevadm)).to receive(:value).and_return('path' => '/foo')
        allow(Facter::Core::Execution).to receive(:exec).with('/foo info -e').and_return(
          File.read(fixtures('udevdb', udevdb_fixture))
        )
      end

      context 'fedora37-supermicro-X10SRA-F' do
        let(:udevdb_fixture) { 'fedora37-supermicro-X10SRA-F.txt' }

        context 'eno1' do
          let(:path) { '/devices/pci0000:00/0000:00:1c.2/0000:0a:00.0/net/eno1' }
          let(:dev) do
            include(
              'path'      => '/devices/pci0000:00/0000:00:1c.2/0000:0a:00.0/net/eno1',
              'ifindex'   => 2,
              'subsystem' => 'net',
              'sysname'   => 'eno1',
              'sysnum'    => '1',
              'property'  => include(
                'DEVPATH'       => '/devices/pci0000:00/0000:00:1c.2/0000:0a:00.0/net/eno1',
                'SYSTEMD_ALIAS' => '/sys/subsystem/net/devices/eno1'
              )
            )
          end

          it_behaves_like 'a path device'
        end

        context 'nvme0n1' do
          let(:name) { 'nvme0n1' }
          let(:path) { '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/nvme/nvme0/nvme0n1' }
          let(:dev) do
            include(
              'name'      => 'nvme0n1',
              'path'      => '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/nvme/nvme0/nvme0n1',
              'symlink'   => include(
                'disk/by-id/nvme-Samsung_SSD_960_EVO_1TB_S3ETNX0J208970A'
              ),
              'devnum'    => 'b 259:0',
              'devtype'   => 'disk',
              'diskseq'   => 3,
              'subsystem' => 'block',
              'sysname'   => 'nvme0n1',
              'sysnum'    => '1',
              'priority'  => 0,
              'property'  => include(
                'DEVNAME'   => '/dev/nvme0n1',
                'ID_SERIAL' => 'Samsung_SSD_960_EVO_1TB_S3ETNX0J208970A',
                'DEVLINKS'  => %w[
                  /dev/disk/by-path/pci-0000:01:00.0-nvme-1
                  /dev/disk/by-id/nvme-Samsung_SSD_960_EVO_1TB_S3ETNX0J208970A
                  /dev/disk/by-diskseq/3
                  /dev/disk/by-id/nvme-eui.0025385271b166c9
                ]
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end
      end

      context 'almalinux9-supermicro-1114S-WN10RT' do
        let(:udevdb_fixture) { 'almalinux9-supermicro-1114S-WN10RT.txt' }

        context 'nvme0n1' do
          let(:name) { 'nvme0n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.1/0000:c1:00.0/nvme/nvme0/nvme0n1' }
          let(:dev) do
            include(
              'name'     => 'nvme0n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.1/0000:c1:00.0/nvme/nvme0/nvme0n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803393'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/nvme-eui.34333930528033930025384300000001
                  /dev/disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803393
                  /dev/disk/by-path/pci-0000:c1:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme0n1',
                'ID_SERIAL' => 'SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803393'
              )
            )
          end

          it_behaves_like 'a named device'
        end

        context 'nvme1n1' do
          let(:name) { 'nvme1n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.2/0000:c2:00.0/nvme/nvme1/nvme1n1' }
          let(:dev) do
            include(
              'name'     => 'nvme1n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.2/0000:c2:00.0/nvme/nvme1/nvme1n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803379'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/lvm-pv-uuid-W8NPeG-qgGf-EbVt-iCn4-OqGj-Sqck-H3E9zg
                  /dev/disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803379
                  /dev/disk/by-path/pci-0000:c2:00.0-nvme-1
                  /dev/disk/by-id/nvme-eui.34333930528033790025384300000001
                ],
                'DEVNAME' => '/dev/nvme1n1',
                'ID_SERIAL' => 'SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803379'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme2n1' do
          let(:name) { 'nvme2n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.3/0000:c3:00.0/nvme/nvme2/nvme2n1' }
          let(:dev) do
            include(
              'name'     => 'nvme2n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.3/0000:c3:00.0/nvme/nvme2/nvme2n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0T503389'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-path/pci-0000:c3:00.0-nvme-1
                  /dev/disk/by-id/nvme-eui.36344730545033890025384500000001
                  /dev/disk/by-id/lvm-pv-uuid-uQ5EER-2ri9-9FFh-O3i1-xrJk-gqyL-uH4HfY
                  /dev/disk/by-id/nvme-SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0T503389
                ],
                'DEVNAME' => '/dev/nvme2n1',
                'ID_SERIAL' => 'SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0T503389'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme3n1' do
          let(:name) { 'nvme3n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.4/0000:c4:00.0/nvme/nvme3/nvme3n1' }
          let(:dev) do
            include(
              'name'     => 'nvme3n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.4/0000:c4:00.0/nvme/nvme3/nvme3n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0T503404'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-path/pci-0000:c4:00.0-nvme-1
                  /dev/disk/by-id/nvme-SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0T503404
                  /dev/disk/by-id/nvme-eui.36344730545034040025384500000001
                  /dev/disk/by-id/lvm-pv-uuid-xzlz4e-rpFc-n5CB-5xrG-lDm2-fJFC-alnXfZ
                ],
                'DEVNAME' => '/dev/nvme3n1',
                'ID_SERIAL' => 'SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0T503404'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme4n1' do
          let(:name) { 'nvme4n1' }
          let(:path) { '/devices/pci0000:40/0000:40:03.6/0000:49:00.0/nvme/nvme4/nvme4n1' }
          let(:dev) do
            include(
              'name'     => 'nvme4n1',
              'path'     => '/devices/pci0000:40/0000:40:03.6/0000:49:00.0/nvme/nvme4/nvme4n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZ1LB960HAJQ-00007_S435NC0T201885'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-path/pci-0000:49:00.0-nvme-1
                  /dev/disk/by-id/nvme-SAMSUNG_MZ1LB960HAJQ-00007_S435NC0T201885
                  /dev/disk/by-id/nvme-eui.34333530542018850025384300000001
                ],
                'DEVNAME' => '/dev/nvme4n1',
                'ID_SERIAL' => 'SAMSUNG_MZ1LB960HAJQ-00007_S435NC0T201885'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end
      end

      context 'almalinux8-supermicro-1114S-WN10RT' do
        let(:udevdb_fixture) { 'almalinux8-supermicro-1114S-WN10RT.txt' }

        context 'nvme0n1' do
          let(:name) { 'nvme0n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.1/0000:c1:00.0/nvme/nvme0/nvme0n1' }
          let(:dev) do
            include(
              'name'     => 'nvme0n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.1/0000:c1:00.0/nvme/nvme0/nvme0n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803379'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/nvme-eui.34333930528033790025384300000001
                  /dev/disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803379
                  /dev/disk/by-path/pci-0000:c1:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme0n1',
                'ID_SERIAL' => 'SAMSUNG MZQLB1T9HAJR-00007_S439NC0R803379'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme1n1' do
          let(:name) { 'nvme1n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.2/0000:c2:00.0/nvme/nvme1/nvme1n1' }
          let(:dev) do
            include(
              'name'     => 'nvme1n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.2/0000:c2:00.0/nvme/nvme1/nvme1n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803393'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/nvme-eui.34333930528033930025384300000001
                  /dev/disk/by-path/pci-0000:c2:00.0-nvme-1
                  /dev/disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0R803393
                ],
                'DEVNAME' => '/dev/nvme1n1',
                'ID_SERIAL' => 'SAMSUNG MZQLB1T9HAJR-00007_S439NC0R803393'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme2n1' do
          let(:name) { 'nvme2n1' }
          let(:path) { '/devices/pci0000:40/0000:40:03.6/0000:49:00.0/nvme/nvme2/nvme2n1' }
          let(:dev) do
            include(
              'name'     => 'nvme2n1',
              'path'     => '/devices/pci0000:40/0000:40:03.6/0000:49:00.0/nvme/nvme2/nvme2n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZ1LB960HAJQ-00007_S435NC0T201885'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/nvme-eui.34333530542018850025384300000001
                  /dev/disk/by-id/nvme-SAMSUNG_MZ1LB960HAJQ-00007_S435NC0T201885
                  /dev/disk/by-path/pci-0000:49:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme2n1',
                'ID_SERIAL' => 'SAMSUNG MZ1LB960HAJQ-00007_S435NC0T201885'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end
      end

      context 'centos7-supermicro-1114S-WN10RT' do
        let(:udevdb_fixture) { 'centos7-supermicro-1114S-WN10RT.txt' }

        context 'nvme0n1' do
          let(:name) { 'nvme0n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.1/0000:c1:00.0/nvme/nvme0/nvme0n1' }
          let(:dev) do
            include(
              'name'     => 'nvme0n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.1/0000:c1:00.0/nvme/nvme0/nvme0n1',
              'symlink'  => include(
                'disk/by-id/nvme-Samsung_SSD_983_DCT_1.92TB_S48BNG0MB01692Z'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/nvme-Samsung_SSD_983_DCT_1.92TB_S48BNG0MB01692Z
                  /dev/disk/by-id/nvme-eui.343842304db016920025384700000001
                  /dev/disk/by-path/pci-0000:c1:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme0n1',
                'ID_SERIAL' => 'Samsung SSD 983 DCT 1.92TB_S48BNG0MB01692Z'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme1n1' do
          let(:name) { 'nvme1n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.2/0000:c2:00.0/nvme/nvme1/nvme1n1' }
          let(:dev) do
            include(
              'name'     => 'nvme1n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.2/0000:c2:00.0/nvme/nvme1/nvme1n1',
              'symlink'  => include(
                'disk/by-id/nvme-Samsung_SSD_983_DCT_1.92TB_S48BNG0MB01685F'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/lvm-pv-uuid-9xd8Cv-b2ix-Po6i-beCm-dJ73-W9Tc-kRWDht
                  /dev/disk/by-id/nvme-Samsung_SSD_983_DCT_1.92TB_S48BNG0MB01685F
                  /dev/disk/by-id/nvme-eui.343842304db016850025384700000001
                  /dev/disk/by-path/pci-0000:c2:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme1n1',
                'ID_SERIAL' => 'Samsung SSD 983 DCT 1.92TB_S48BNG0MB01685F'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme2n1' do
          let(:name) { 'nvme2n1' }
          let(:path) { '/devices/pci0000:c0/0000:c0:01.3/0000:c3:00.0/nvme/nvme2/nvme2n1' }
          let(:dev) do
            include(
              'name'     => 'nvme2n1',
              'path'     => '/devices/pci0000:c0/0000:c0:01.3/0000:c3:00.0/nvme/nvme2/nvme2n1',
              'symlink'  => include(
                'disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0RA01816'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/lvm-pv-uuid-BURjmT-eLdd-RzoT-xJQm-z4lJ-zkkk-otZ7MT
                  /dev/disk/by-id/nvme-SAMSUNG_MZQLB1T9HAJR-00007_S439NC0RA01816
                  /dev/disk/by-id/nvme-eui.3433393052a018160025384300000001
                  /dev/disk/by-path/pci-0000:c3:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme2n1',
                'ID_SERIAL' => 'SAMSUNG MZQLB1T9HAJR-00007_S439NC0RA01816'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end

        context 'nvme3n1' do
          let(:name) { 'nvme3n1' }
          let(:path) { '/devices/pci0000:40/0000:40:03.6/0000:49:00.0/nvme/nvme3/nvme3n1' }
          let(:dev) do
            include(
              'name'     => 'nvme3n1',
              'path'     => '/devices/pci0000:40/0000:40:03.6/0000:49:00.0/nvme/nvme3/nvme3n1',
              'symlink'  => include(
                'disk/by-id/nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0NA00569R'
              ),
              'property' => include(
                'DEVLINKS' => %w[
                  /dev/disk/by-id/nvme-Samsung_SSD_980_PRO_500GB_S5NYNG0NA00569R
                  /dev/disk/by-id/nvme-eui.002538ba01501163
                  /dev/disk/by-path/pci-0000:49:00.0-nvme-1
                ],
                'DEVNAME' => '/dev/nvme3n1',
                'ID_SERIAL' => 'Samsung SSD 980 PRO 500GB_S5NYNG0NA00569R'
              )
            )
          end

          it_behaves_like 'a named device'
          it_behaves_like 'a path device'
        end
      end
    end

    context 'when udevadm is not present' do
      before do
        allow(Facter.fact(:udevadm)).to receive(:value).and_return(false)
      end

      it { expect(fact.value).to be_nil }
    end
  end

  context 'when kernel is not Linux' do
    let(:kernel) { 'Windows' }

    before do
      allow(Facter.fact(:kernel)).to receive(:value).and_return('Windows')
    end

    it { expect(fact.value).to be_nil }
  end
end
